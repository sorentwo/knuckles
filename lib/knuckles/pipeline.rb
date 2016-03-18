module Knuckles
  class Pipeline
    def self.default_stages
      [Knuckles::Fetcher,
       Knuckles::Hydrator,
       Knuckles::Renderer,
       Knuckles::Writer,
       Knuckles::Combiner,
       Knuckles::Dumper]
    end

    attr_accessor :stages

    def initialize(stages: self.class.default_stages)
      @stages = stages
    end

    def call(objects, options)
      prepared = prepare(objects)

      stages.reduce(prepared) do |results, stage|
        instrument("knuckles.stage", stage: stage.name) do
          stage.call(results, options)
        end
      end
    end

    def prepare(objects)
      objects.map do |object|
        {object: object, key: nil, cached?: false, result: nil}
      end
    end

    private

    def instrument(operation, payload, &block)
      Knuckles.notifications.instrument(operation, payload, &block)
    end
  end
end
