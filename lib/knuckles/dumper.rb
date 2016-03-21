module Knuckles
  module Dumper
    extend self

    def name
      "dumper".freeze
    end

    def call(objects, _options)
      Knuckles.serializer.dump(keys_to_arrays(objects))
    end

    private

    def keys_to_arrays(objects)
      objects.each do |key, value|
        objects[key] = value.to_a if value.is_a?(Set)
      end
    end
  end
end
