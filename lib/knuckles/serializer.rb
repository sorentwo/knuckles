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

    def as_json
      self.class.attributes.each_with_object({}) do |prop, memo|
        memo[prop] = public_send(prop)
      end
    end

    def to_json
      Knuckles.json.dump(as_json)
    end

    def cache_key
      [object_cache_key, child_cache_key].compact
    end

    def cached?
      !!serialized
    end

    private

    def object_cache_key
      object.cache_key
    end

    def child_cache_key
      if children.any?
        children.max_by(&:updated_at).cache_key
      end
    end
  end
end
