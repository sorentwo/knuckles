# frozen_string_literal: true

module Knuckles
  module Stages
    module Hydrator
      extend self

      def call(prepared, options)
        hydrate = options[:hydrate]

        if hydrate && any_missing?(prepared)
          hydrate.call(hydratable(prepared))
        end

        prepared
      end

      private

      def any_missing?(prepared)
        prepared.any? { |hash| !hash[:cached?] }
      end

      def hydratable(prepared)
        prepared.reject { |hash| hash[:cached?] }
      end
    end
  end
end
