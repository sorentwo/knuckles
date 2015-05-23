module Knuckles
  class Pipeline
    class BuildFilter < Filter
      def call
        output = nodes.each_with_object(array_backed_hash) do |node, memo|
          memo[node.root] << node.serialized
        end

        jsonify_hash(output)
      end

      private

      def array_backed_hash
        Hash.new { |hash, key| hash[key] = [] }
      end

      def jsonify_hash(hash, buffer = "")
        length = hash.length - 1

        buffer << "{"

        hash.each_with_index do |(key, value), index|
          buffer << "\"#{key}\":"
          buffer << "[#{value.join(',')}]"
          buffer << "," if index < length
        end

        buffer << "}"
      end
    end
  end
end
