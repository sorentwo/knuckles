module Knuckles
  class Node
    attr_reader :object
    attr_accessor :serializer, :dependencies, :serialized

    def initialize(object, serializer: nil, dependencies: nil, serialized: nil)
      @object       = object
      @serializer   = serializer
      @dependencies = dependencies || {}
      @serialized   = serialized
    end

    def cache_key
      [serializer_cache_key, dependency_cache_key].compact
    end

    private

    def serializer_cache_key
      if serializer.respond_to?(:cache_key)
        serializer.cache_key
      else
        object.cache_key
      end
    end

    def dependency_cache_key
      if dependencies.any?
        dependencies
          .flat_map { |_, set| set.to_a }
          .max_by { |dep| dep.updated_at }
          .cache_key
      end
    end
  end
end
