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

      def build_children(node)
        serializer = node.serializer

        serializer.class.includes.flat_map do |key, klass|
          children = serializer.public_send(key)

          [children].flatten.compact.map do |child|
            Node.new(child, serializer: klass.new(child))
          end
        end
      end
    end
  end
end
