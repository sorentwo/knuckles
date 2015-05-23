module Knuckles
  class Pipeline
    class SerializeFilter < Filter
      def call
        nodes.each do |node|
          unless node.serialized
            node.serialized = node.to_json
          end
        end
      end
    end
  end
end
