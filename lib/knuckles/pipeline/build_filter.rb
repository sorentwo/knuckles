module Knuckles
  class Pipeline
    class BuildFilter < Filter
      def call
        nodes
      end
    end
  end
end
