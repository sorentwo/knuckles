# frozen_string_literal: true

module Knuckles
  class Pipeline
    def self.default_stages
      [Knuckles::Stages::Fetcher,
       Knuckles::Stages::Hydrator,
       Knuckles::Stages::Renderer,
       Knuckles::Stages::Writer,
       Knuckles::Stages::Enhancer,
       Knuckles::Stages::Combiner,
       Knuckles::Stages::Dumper]
    end

    attr_reader :stages

    def initialize(stages: self.class.default_stages)
      @stages = stages
    end

    def delete(stage)
      stages.delete(stage)
    end

    def insert_after(stage, new_stage)
      index = stages.index(stage)

      stages.insert(index + 1, new_stage)
    end

    def insert_before(stage, new_stage)
      index = stages.index(stage)

      stages.insert(index, new_stage)
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
