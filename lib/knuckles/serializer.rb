module Knuckles
  class Serializer
    class << self
      attr_reader :_root, :_attributes, :_relations

      def attributes(*attributes)
        @_attributes = attributes.zip(attributes).to_h

        @_attributes.each_key { |attribute| define_attribute(attribute) }
      end

      def root(root)
        @_root = root
      end

      def has_one(key, serializer:)
        associate(key, Knuckles::Relation::HasOne.new(key, serializer))
      end

      def has_many(key, serializer:)
        associate(key, Knuckles::Relation::HasMany.new(key, serializer))
      end

      def associate(key, relation)
        (@_relations ||= {})[key] = relation

        define_attribute(key)
      end

      private

      def define_attribute(attribute)
        unless method_defined?(attribute)
          define_method(attribute) do
            object.send(attribute)
          end
        end
      end
    end

    attr_accessor :object, :options, :children, :scope, :serialized

    def initialize(object, options = {})
      @object   = object
      @options  = options
      @children = options.fetch(:children, [])
      @scope    = options.fetch(:scope, nil)
    end

    def attributes
      self.class._attributes || {}
    end

    def relations
      self.class._relations || {}
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
      [object.cache_key, child_cache_key].compact.flatten
    end

    private

    def child_cache_key
      if children.any?
        [children.length.to_s, children.max_by(&:updated_at).cache_key]
      end
    end

    def relation_attributes
      relations.each_with_object({}) do |(key, relation), memo|
        memo[relation.attribute_key] = relation.ids(self)
      end
    end

    def serialized_attributes
      attributes.each_with_object({}) do |(key, _), memo|
        memo[key] = send(key)
      end
    end
  end
end
