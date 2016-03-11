module Knuckles
  module Fetcher
    extend self

    def name
      "Fetcher".freeze
    end

    def call(objects, view:)
      objects.map do |object|
        key = view.cache_key(object)

        {key: key, object: object, result: Knuckles.cache.read(key)}
      end
    end
  end
end
