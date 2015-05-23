module Knuckles
  class Pipeline
    class ChildrenFilter < Filter
      def call
        parents = nodes.dup

        while node = parents.shift
          node.children = build_children(node)
          parents += node.children
        end

        nodes
      end

      private

      def build_children(node)
        serializer = node.serializer

        # TODO: Bug with wrapping an empty list (comments)
        serializer.class.includes.flat_map do |key, klass|
          if child = serializer.public_send(key)
            build_node(node, child, klass)
          end
        end.compact
      end

      def build_node(parent, child, serializer)
        if child.is_a?(Array)
          child.map { |rel| build_node(parent, rel, serializer) }
        else
          Node.new(child, parent: parent, serializer: serializer.new(child))
        end
      end
    end
  end
end
