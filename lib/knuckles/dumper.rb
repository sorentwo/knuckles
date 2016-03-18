module Knuckles
  module Dumper
    extend self

    def call(objects, options)
      Knuckles.serializer.dump(set_keys_to_arrays(objects))
    end

    private

    def set_keys_to_arrays(objects)
      objects.each do |key, value|
        objects[key] = value.to_a
      end
    end
  end
end
