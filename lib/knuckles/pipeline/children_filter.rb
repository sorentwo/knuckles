module Knuckles
  class Pipeline
    class ChildrenFilter < Filter
      def call
        array = nodes
        index = 0

        while node = array[index]
          node.children = build_children(node)
          array += node.children
          index += 1
        end

        array
      end

      private

      def build_children(serializer)
        serializer.relations.flat_map do |relation|
          relation.serializables(serializer)
        end
      end
    end
  end
end
