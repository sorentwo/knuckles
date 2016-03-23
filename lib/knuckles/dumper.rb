# frozen_string_literal: true

module Knuckles
  module Dumper
    extend self

    def name
      "dumper"
    end

    def call(objects, _options)
      Knuckles.serializer.dump(keys_to_arrays(objects))
    end

    private

    def keys_to_arrays(objects)
      objects.each do |_, value|
        if value.is_a?(Array)
          value.uniq! { |hash| hash["id"] || hash[:id] }
        end
      end
    end
  end
end
