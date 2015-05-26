require "delegate"

module Knuckles
  class Serializer < SimpleDelegator
    class << self
      attr_reader :_root, :_attributes, :_relations

      def attributes(*attributes)
        @_attributes = attributes
      end

      def root(root)
        @_root = root
      end

      def has_one(relation, serializer:)
        associate(Knuckles::Relation::HasOne.new(relation, serializer))
      end

      def has_many(relation, serializer:)
        associate(Knuckles::Relation::HasMany.new(relation, serializer))
      end

      def associate(relation)
        (@_relations ||= []) << relation
      end
    end

    attr_accessor :object, :options, :children, :scope, :serialized

    def initialize(object, options = {})
      super(object)

      @object   = object
      @options  = options
      @children = options.fetch(:children, [])
      @scope    = options.fetch(:scope, nil)
    end

    def attributes
      filter(self.class._attributes || [])
    end

    def relations
      self.class._relations || []
    end

    def root
      self.class._root
    end

    def filter(keys)
      keys
    end

    def as_json
      serialized_attributes.merge(relation_attributes)
    end

    def to_json
      Knuckles.json.dump(as_json)
    end

    def cache_key
      [object.cache_key, child_cache_key].compact
    end

    def cached?
      !!serialized
    end

    private

    def child_cache_key
      if children.any?
        children.max_by(&:updated_at).cache_key
      end
    end

    def relation_attributes
      relations.each_with_object({}) do |relation, memo|
        memo[relation.attribute_key] = relation.ids(self)
      end
    end

    def serialized_attributes
      attributes.each_with_object({}) do |prop, memo|
        memo[prop] = public_send(prop)
      end
    end
  end
end
