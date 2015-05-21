module Knuckles
  class Pipeline
    class NodeFilter < Filter
      def call
        serializer = context.fetch(:serializer)

        objects.map do |object|
          Node.new(object, serializer: serializer.new(object))
        end
      end
    end
  end
end
