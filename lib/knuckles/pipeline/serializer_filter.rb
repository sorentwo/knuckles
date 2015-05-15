module Knuckles
  class Pipeline
    class SerializerFilter < Filter
      def call
        serializer = context.fetch(:serializer)

        nodes.map { |node| serializer.new(node) }
      end
    end
  end
end
