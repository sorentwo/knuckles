module Knuckles
  module Fetcher
    extend self

    def name
      "fetcher".freeze
    end

    def call(objects, options)
      view = options.fetch(:view)

      objects.each do |hash|
        key = view.cache_key(hash[:object])
        res = Knuckles.cache.read(key)

        hash[:key] = key
        hash[:cached?] = !res.nil?
        hash[:result] = res
      end
    end
  end
end
