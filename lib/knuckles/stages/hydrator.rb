# frozen_string_literal: true

module Knuckles
  module Stages
    # The hydrator converts minimal objects in a prepared collection into fully
    # "hydrated" versions of the same record. For example, the initial `model`
    # may only have the `id` and `updated_at` timestamp selected, which is
    # ideal for fetching from the cache. If the object wasn't in the cache then
    # all of the fields are needed for a complete rendering, so the hydration
    # call will use the passed relation to fetch the full model and any
    # associations.
    #
    # This is a generic hydrator suitable for any type of collection.  If you
    # are working with `ActiveRecord` you'll want to use the
    # `Knuckles::Active::Hydrator` module instead.
    module Hydrator
      extend self

      # Convert all uncached objects into their full representation.
      #
      # @param [Enumerable] prepared The prepared collection for processing
      # @option [Proc, #call] :hydrate A proc used to load missing data for
      #   uncached objects
      #
      # @example Hydrating missing objects
      #
      #   Knuckles::Hydrator.call(
      #     prepared,
      #     hydrate: -> (objects) { objects.each(&:fetch!) }
      #   )
      #
      def call(prepared, options)
        hydrate = options[:hydrate]

        if hydrate && any_missing?(prepared)
          hydrate.call(hydratable(prepared))
        end

        prepared
      end

      private

      def any_missing?(prepared)
        prepared.any? { |hash| !hash[:cached?] }
      end

      def hydratable(prepared)
        prepared.reject { |hash| hash[:cached?] }
      end
    end
  end
end
