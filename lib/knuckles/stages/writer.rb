# frozen_string_literal: true

module Knuckles
  module Stages
    # After un-cached models have been serialized they are ready to be cached
    # for future retrieval. Each fully serialized model is written to the cache
    # in a single `write_multi` operation if available (using Readthis, for
    # example). Only previously un-cached data will be written to the cache,
    # making the writer a no-op when all of the data was cached initially.
    module Writer
      extend self

      # Write all serialized, but previously un-cached, data to the cache.
      #
      # @param [Enumerable] objects A collection of hashes to be serialized,
      #   each hash must have they keys `:key`, `:result`, and `:cached?`.
      # @param [Hash] _options Options aren't used, but are accepted
      #   to maintain a consistent interface
      # @return The original enumerable is returned unchanged
      #
      def call(objects, _options)
        if cache.respond_to?(:write_multi)
          write_multi(objects)
        else
          write_each(objects)
        end

        objects
      end

      private

      def cache
        Knuckles.cache
      end

      def write_each(objects)
        objects.each do |hash|
          cache.write(hash[:key], hash[:result]) unless hash[:cached?]
        end
      end

      def write_multi(objects)
        writable = objects.each_with_object({}) do |hash, memo|
          next if hash[:cached?]

          memo[hash[:key]] = hash[:result]
        end

        cache.write_multi(writable) if writable.any?
      end
    end
  end
end
