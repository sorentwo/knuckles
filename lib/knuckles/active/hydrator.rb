# frozen_string_literal: true

module Knuckles
  module Active
    # The active hydrator converts minimal objects in a prepared collection
    # into fully "hydrated" versions of the same record. For example, the
    # initial `model` may only have the `id` and `updated_at` timestamp
    # selected, which is ideal for fetching from the cache. If the object
    # wasn't in the cache then all of the fields are needed for a complete
    # rendering, so the hydration call will use the passed relation to fetch
    # the full model and any associations.
    #
    # This `Hydrator` module is specifically designed to work with
    # `ActiveRecord` relations. The initial objects can be anything that
    # responds to `id`, but the relation should be an `ActiveRecord` relation.
    module Hydrator
      extend self

      # Convert all uncached objects into their full representation.
      #
      # @param [Enumerable] prepared The prepared collection for processing
      # @option [#Relation] :relation An ActiveRecord::Relation, used to
      #   hydrate uncached objects
      #
      # @example Hydrating missing objects
      #
      #   relation = Post.all.preload(:author, :comments)
      #   prepared = relation.select(:id, :updated_at)
      #
      #   Knuckles::Active::Hydrator.call(prepared, relation: relation) #=>
      #     # [{object: #Post<1>, cached?: false, ...
      #
      def call(prepared, options)
        mapping = id_object_mapping(prepared)

        if mapping.any?
          relation = relation_without_pagination(options)

          relation.where(id: mapping.keys).each do |hydrated|
            mapping[hydrated.id][:object] = hydrated
          end
        end

        prepared
      end

      private

      def relation_without_pagination(options)
        options.fetch(:relation).offset(false).limit(false)
      end

      def id_object_mapping(objects)
        objects.each_with_object({}) do |hash, memo|
          next if hash[:cached?]

          memo[hash[:object].id] = hash
        end
      end
    end
  end
end
