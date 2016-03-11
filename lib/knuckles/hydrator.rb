module Knuckles
  module Hydrator
    extend self

    def name
      "hydrator".freeze
    end

    def call(objects, hydrate: nil)
      if hydrate
        hydrate.call(objects)
      else
        objects
      end
    end
  end
end
