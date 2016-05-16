# frozen_string_literal: true

module Knuckles
  module Stages
    # The combiner stage merges all of the individually rendered results into a
    # single hash. The output of this stage is a single object with string keys
    # and array values, ready to be serialized.
    module Combiner
      extend self

      # Merge all of the rendered data into a single hash. Each
      # resulting value will be an array, even if there was only one
      # value in the original rendered results.
      #
      # @param [Enumerable] prepared The prepared collection to be combined
      # @param [Hash] _options Options aren't used, but are accepted
      #   to maintain a consistent interface
      #
      # @example Combining rendered data
      #
      #     prepared = [
      #       {
      #         result: {
      #           author: {id: 1, name: "Michael"},
      #           posts: [{id: 1, title: "hello"}],
      #         }
      #       }, {
      #         result: {
      #           author: {id: 1, name: "Michael"},
      #           posts: [{id: 2, title: "there"}],
      #         }
      #       }
      #     ]
      #
      #     Knuckles::Stage::Combiner.call(prepared, {}) #=> {
      #       "author" => [
      #         {id: 1, name: "Michael"}
      #       ],
      #       "posts" => [
      #         {id: 1, title: "hello"},
      #         {id: 2, title: "there"}
      #       ]
      #     }
      #
      def call(prepared, _options)
        prepared.each_with_object(array_backed_hash) do |hash, memo|
          hash[:result].each do |root, values|
            case values
            when Hash  then memo[root.to_s] << values
            when Array then memo[root.to_s] += values
            end
          end
        end
      end

      private

      def array_backed_hash
        Hash.new { |hash, key| hash[key] = [] }
      end
    end
  end
end
