module Knuckles
  class Pipeline
    class CacheFilter < Filter
      attr_accessor :cache

      def call
        mapping = cache_key_mapping
        values  = cache.read_multi(*mapping.keys)

        values.each do |key, value|
          if node = mapping[key]
            node.serialized = value
          end
        end

        nodes
      end

      private

      def cache_key_mapping
        nodes.each_with_object({}) do |node, memo|
          memo[node.cache_key] = node
        end
      end
    end
  end
end
