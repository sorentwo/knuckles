require 'set'

module Knuckles
  class Pipeline
    class DependencyFilter < Filter
      def call
        nodes.map do |node|
          node.dependencies = extract_dependencies(node.serializer)
          node
        end
      end

      private

      def extract_dependencies(serializer)
        serializer.class.includes.each_with_object(set_backed_hash) do |(key, _), hash|
          case relation = serializer.public_send(key)
          when Array then hash[key] += relation
          when nil   then hash[key]
          else hash[key] << relation
          end
        end
      end

      def set_backed_hash
        Hash.new { |k, v| k[v] = Set.new }
      end
    end
  end
end
