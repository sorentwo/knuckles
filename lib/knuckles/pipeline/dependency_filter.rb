require 'set'

module Knuckles
  class Pipeline
    class DependencyFilter < Filter
      def call
        includes = nil

        nodes.map do |node|
          includes ||= node.class.includes
          node.dependencies = extract_dependencies(includes, node)
          node
        end
      end

      private

      def extract_dependencies(includes, node)
        includes.each_with_object(set_backed_hash) do |(key, _), hash|
          case relation = node.public_send(key)
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
