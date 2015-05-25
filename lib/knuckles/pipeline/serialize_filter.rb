module Knuckles
  class Pipeline
    class SerializeFilter < Filter
      def call
        nodes.each do |node|
          node.serialized = node.to_json unless node.cached?
        end
      end
    end
  end
end
