module Knuckles
  module Fetcher
    extend self

    def name
      "Fetcher".freeze
    end

    def call(objects, view:)
      objects.map do |hash|
        key = view.cache_key(hash[:object])

        hash[:key] = key
        hash[:result] = Knuckles.cache.read(key)

        hash
      end
    end
  end
end
