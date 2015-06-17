module Knuckles
  class KeyStrategy
    def cache_key(object, children = [])
      "#{base_cache_key(object)}/#{children_cache_key(children)}"
    end

    private

    def base_cache_key(object)
      "#{object.class.name}/#{object.id}/#{object.updated_at.to_i}"
    end

    def children_cache_key(children)
      "#{children.length}/#{max_updated_at(children)}"
    end

    def max_updated_at(children)
      if child = children.max_by(&:updated_at)
        child.updated_at.to_i
      end
    end
  end
end
