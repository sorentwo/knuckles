module Knuckles
  class Builder
    class Filter
      def self.call(nodes, context = {})
        new(nodes, context).call
      end

      attr_reader :nodes, :context

      def initialize(nodes, context = {})
        @nodes   = nodes
        @context = context
      end

      def call
        raise NotImplementedError
      end
    end
  end
end
