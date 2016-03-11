module Knuckles
  class Pipeline
    def self.default_stages
      [Knuckles::Fetcher,
       Knuckles::Hydrator,
       Knuckles::Renderer,
       Knuckles::Combiner]
    end

    attr_accessor :stages

    def initialize(stages: self.class.default_stages)
      @stages = stages
    end

    def call(objects, options)
      prepared = Knuckles.prepare(objects)

      stages.reduce(prepared) do |results, filter|
        instrument('knuckles.filter', filter: filter.name) do
          filter.call(results, options)
        end
      end
    end

    private

    def instrument(operation, payload, &block)
      Knuckles.notifications.instrument(operation, payload, &block)
    end
  end
end
