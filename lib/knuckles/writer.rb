module Knuckles
  module Writer
    extend self

    def name
      "writer".freeze
    end

    def call(objects, _)
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
