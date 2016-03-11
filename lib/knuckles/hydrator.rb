module Knuckles
  module Hydrator
    extend self

    def name
      "hydrator".freeze
    end

    def call(objects, options)
      if hydrate = options[:hydrate]
        hydrate.call(hydratable(objects))
      else
        objects
      end
    end

    private

    def hydratable(objects)
      objects.reject { |hash| hash[:result] }
    end
  end
end
