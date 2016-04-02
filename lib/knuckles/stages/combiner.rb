# frozen_string_literal: true

module Knuckles
  module Stages
    module Combiner
      extend self

      def call(prepared, _)
        prepared.each_with_object(array_backed_hash) do |hash, memo|
          hash[:result].each do |root, values|
            case values
            when Hash  then memo[root.to_s] << values
            when Array then memo[root.to_s] += values
            end
          end
        end
      end

      def array_backed_hash
        Hash.new { |hash, key| hash[key] = [] }
      end
    end
  end
end
