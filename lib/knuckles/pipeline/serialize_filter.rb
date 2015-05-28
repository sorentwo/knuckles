module Knuckles
  class Pipeline
    class SerializeFilter < Filter
      def call
        mapping = cache_key_mapping

        fetched = Knuckles.cache.fetch_multi(*mapping.keys) do |key|
          mapping[key].to_json
        end

        mapping.each do |key, node|
          node.serialized = fetched[key]
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
