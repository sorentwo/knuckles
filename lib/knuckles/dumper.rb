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
      objects.each do |_, value|
        value.uniq! if value.is_a?(Array)
      end
    end
  end
end
