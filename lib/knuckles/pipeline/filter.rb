module Knuckles
  class Pipeline
    class Filter
      def self.call(nodes, context = nil, result = nil)
        new(nodes, context, result).call
      end

      attr_reader :nodes, :context, :result

      def initialize(nodes, context = nil, result = nil)
        @nodes   = nodes
        @context = context
        @result  = result
      end

      alias_method :objects, :nodes

      def call
        raise NotImplementedError
      end
    end
  end
end
