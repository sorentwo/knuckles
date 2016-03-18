module Knuckles
  module Keygen
    extend self

    def expand_key(object)
      if object.respond_to?(:cache_key)
        object.cache_key
      else
        "#{object.class.name}/#{object.id}/#{object.updated_at.to_i}"
      end
    end
  end
end
