# frozen_string_literal: true

module Knuckles
  module Stages
    # The enhancer modifies rendered data using proc passed through options.
    # The enhancer stage is critical to customizing the final output. For
    # example, if staff should have confidential data that regular users can't
    # see you can enhance the final values. Another use of enhancers is
    # personalizing an otherwise generic response.
    module Enhancer
      extend self

      # Modify all results using an `enhancer` proc.
      #
      # @param [Enumerable] prepared The prepared collection to be enhanced
      # @option [Proc] :enhancer A `proc`, `lambda`, or any object that responds
      #   to `call`. Every complete `result` in the prepared collection will be
      #   passed to the enhancer.
      #
      # @example Removing tags unless the scope is staff
      #
      #    enhancer = lambda do |result, options|
      #      scope = options[:scope]
      #
      #      unless scope.staff?
      #        result.delete_if { |key, _| key == "tags" }
      #      end
      #
      #      result
      #    end
      #
      #    prepared = [{result: {"posts" => [], "tags" => []}}]
      #
      #    Knuckles::Stages::Enhancer.call(prepared, enhancer: enhancer) #=>
      #     # [{result: {"posts" => []}}]
      #
      def call(prepared, options)
        enhancer = options[:enhancer]

        if enhancer
          prepared.each do |hash|
            hash[:result] = enhancer.call(hash[:result], options)
          end
        end

        prepared
      end
    end
  end
end
