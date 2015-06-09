require 'set'

module Knuckles
  class Builder
    class BuildFilter < Filter
      def call
        output = nodes.each_with_object(set_backed_hash) do |node, memo|
          memo[node.root] << node.serialized if node.serialized
        end

        jsonify_hash(output)
      end

      private

      def set_backed_hash
        Hash.new { |hash, key| hash[key] = Set.new }
      end

      def jsonify_hash(hash, buffer = "")
        length = hash.length - 1

        buffer << "{"

        hash.each_with_index do |(key, value), index|
          buffer << "\"#{key}\":"
          buffer << "[#{value.to_a.join(',')}]"
          buffer << "," if index < length
        end

        buffer << "}"
      end
    end
  end
end
