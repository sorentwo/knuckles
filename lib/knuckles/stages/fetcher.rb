# frozen_string_literal: true

module Knuckles
  module Stages
    # The fetcher is responsible for bulk retrieval of data from the cache.
    # Fetching is done using a single `read_multi` operation, which is
    # multiplexed in caches like Redis or MemCached.
    #
    # The underlying cache *must* support `read_multi` for the stage to work.
    module Fetcher
      extend self

      # Fetch all previously cached objects from the configured store.
      #
      # @param [Enumerable] prepared The prepared collection to fetch
      # @option [Module] :keygen (Knuckles.keygen) The cache key generator used
      #   to construct an entries cache_key. It can be any object that responds
      #   to `expand_key`
      #
      # @example Provide a custom keygen
      #
      #     keygen = Module.new do
      #       def self.expand_key(object)
      #         object.name
      #       end
      #     end
      #
      #     Knuckles::Stages::Fetcher.call(prepared, keygen: keygen)
      #
      # @example Use a lambda as a keygen
      #
      #     Knuckles::Stages::Fetcher.call(
      #       prepared,
      #       keygen: -> (object) { object.name }
      #     )
      #
      def call(prepared, options)
        results = get_cached(prepared, options)

        prepared.each do |hash|
          hash[:result] = results[hash[:key]]
          hash[:cached?] = !hash[:result].nil?
        end
      end

      private

      def get_cached(prepared, options)
        kgen = options.fetch(:keygen, Knuckles.keygen)
        keys = prepared.map do |hash|
          hash[:key] = expand_key(kgen, hash[:object])
        end

        Knuckles.cache.read_multi(*keys)
      end

      def expand_key(keygen, object)
        if keygen.respond_to?(:call)
          keygen.call(object)
        else
          keygen.expand_key(object)
        end
      end
    end
  end
end
