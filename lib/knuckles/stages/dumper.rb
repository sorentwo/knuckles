# frozen_string_literal: true

module Knuckles
  module Stages
    # The dumping process combines de-duplication and actual serialization. For
    # every top level key that is an array all of the children will have
    # uniqueness enforced. For example, if you had rendered a collection of
    # posts that shared the same author, you will only have a single author
    # object serialized. Be aware that the uniqueness check relies on the
    # presence of an `id` key rather than full object comparisons.
    module Dumper
      extend self

      # De-duplicate values in all keys and merge them into a single hash.
      # Afterwards the complete hash is serialized using the serializer
      # configured at `Knuckles.serializer`.
      #
      # @param [Enumerable] objects A collection of hashes to be dumped
      # @param [Hash] _options Options aren't used, but are accepted
      #   to maintain a consistent interface
      #
      def call(objects, _options)
        Knuckles.serializer.dump(keys_to_arrays(objects))
      end

      private

      def keys_to_arrays(objects)
        objects.each do |_, value|
          if value.is_a?(Array)
            value.uniq! { |hash| hash["id"] || hash[:id] }
          end
        end
      end
    end
  end
end
