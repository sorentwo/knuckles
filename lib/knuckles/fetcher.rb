module Knuckles
  module Fetcher
    extend self

    def name
      "fetcher".freeze
    end

    def call(prepared, options)
      results = get_cached(prepared, options.fetch(:view))

      prepared.each do |hash|
        result = results[hash[:key]]
        hash[:cached?] = !result.nil?
        hash[:result] = result
      end
    end

    private

    def get_cached(prepared, view)
      keys = prepared.map do |hash|
        hash[:key] = view.cache_key(hash[:object])
      end

      Knuckles.cache.read_multi(*keys)
    end
  end
end
