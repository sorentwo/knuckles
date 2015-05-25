module Knuckles
  class Serializer < SimpleDelegator
    attr_accessor :object, :children, :serialized

    def self.root(root)
      @_root = root
    end

    def self._root
      @_root
    end

    def self.attributes(*attributes)
      @_attributes = attributes
    end

    def self._attributes
      @_attributes ||= []
    end

    def self.has_one(relation, serializer:)
      @_relations ||= []
      @_relations << Knuckles::Relation::HasOne.new(relation, serializer)
    end

    def self.has_many(relation, serializer:)
      @_relations ||= []
      @_relations << Knuckles::Relation::HasMany.new(relation, serializer)
    end

    def self._relations
      @_relations || []
    end

    def initialize(object, children: [], serialized: nil)
      super(object)

      @object     = object
      @children   = children
      @serialized = serialized
    end

    def attributes
      self.class._attributes
    end

    def relations
      self.class._relations
    end

    def root
      self.class._root
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
