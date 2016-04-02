# frozen_string_literal: true

module Knuckles
  module Fetcher
    extend self

    def call(prepared, options)
      results = get_cached(prepared, options)

      prepared.each do |hash|
        result = results[hash[:key]]
        hash[:cached?] = !result.nil?
        hash[:result] = result
      end
    end

    private

    def get_cached(prepared, options)
      kgen = options.fetch(:keygen, Knuckles.keygen)
      keys = prepared.map do |hash|
        hash[:key] = kgen.expand_key(hash[:object])
      end

      Knuckles.cache.read_multi(*keys)
    end
  end
end
