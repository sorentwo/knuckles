module Knuckles
  class Serializer
    def attributes
      []
    end

    def ignored(object)
      []
    end

    def serialize(object)
      included_attributes(object).each_with_object({}) do |prop, memo|
        memo[prop] = if self.respond_to?(prop)
          self.public_send(prop, object)
        else
          object.public_send(prop)
        end
      end
    end

    protected

    def included_attributes(object)
      attributes - ignored(object)
    end
  end
end
