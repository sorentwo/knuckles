module Knuckles
  class Pipeline
    class SerializerFilter < Filter
      def call
        serializer = context.fetch(:serializer)

        nodes.map do |node|
          node.serializer = serializer.new(node.object)
          node
        end
      end
    end
  end
end
