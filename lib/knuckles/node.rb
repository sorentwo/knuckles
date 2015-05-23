module Knuckles
  class Node
    attr_reader :object
    attr_writer :cached
    attr_accessor :children, :parent, :root, :serializer, :serialized

    def initialize(object,
                   children: [],
                   parent: nil,
                   root: nil,
                   serializer: nil,
                   serialized: nil)

      @object     = object
      @children   = children
      @parent     = parent
      @serialized = serialized
      @serializer = serializer
      @root       = root
    end

    def cached?
      !!@cached
    end

    def cache_key
      [serializer_cache_key, child_cache_key].compact
    end

    private

    def serializer_cache_key
      if serializer.respond_to?(:cache_key)
        serializer.cache_key
      else
        object.cache_key
      end
    end

    def child_cache_key
      if children.any?
        children.map(&:object).max_by(&:updated_at).cache_key
      end
    end
  end
end
