module Knuckles
  class Pipeline
    class CacheWriteFilter < Filter
      def call
        cache = Knuckles.cache

        nodes.reject(&:cached?).each do |node|
          cache.write(node.cache_key, node.serialized)
        end

        nodes
      end
    end
  end
end
