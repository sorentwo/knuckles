module Knuckles
  class Pipeline
    class NodeFilter < Filter
      def call
        nodes.map { |node| Node.new(node) }
      end
    end
  end
end
