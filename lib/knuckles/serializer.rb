module Knuckles
  class Serializer < SimpleDelegator
    attr_accessor :object, :children, :serialized

    def self.root
      nil
    end

    def self.includes
      {}
    end

    def self.attributes
      []
    end

    def initialize(object, children: [], serialized: nil)
      super(object)

      @object     = object
      @children   = children
      @serialized = serialized
    end

    def root
      self.class.root
    end

    def as_json
      serialized_attributes.merge(includes_attributes)
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

    def includes_attributes
      self.class.includes.each_with_object({}) do |(key, _), memo|
        included    = public_send(key)
        include_ids = included.is_a?(Array) ? included.map(&:id) : included.id

        memo[include_key(key)] = include_ids
      end
    end

    def serialized_attributes
      self.class.attributes.each_with_object({}) do |prop, memo|
        memo[prop] = public_send(prop)
      end
    end

    def include_key(key)
      "#{key.to_s.sub(/s$/, '')}_ids".to_sym
    end
  end
end
