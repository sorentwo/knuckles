module Knuckles
  class Pipeline
    class WrapFilter < Filter
      alias_method :objects, :nodes

      def call
        serializer = context.fetch(:serializer)

        objects.map do |object|
          serializer.new(object)
        end
      end
    end
  end
end
