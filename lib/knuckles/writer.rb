module Knuckles
  module Writer
    extend self

    def name
      "writer".freeze
    end

    def call(objects, _)
      objects.each do |hash|
        write(hash[:key], hash[:result]) unless hash[:cached?]
      end
    end

    private

    def write(key, value)
      Knuckles.cache.write(key, value)
    end
  end
end
