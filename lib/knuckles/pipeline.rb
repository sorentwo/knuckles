module Knuckles
  class Pipeline
    def self.default_stages
      [Knuckles::Renderer]
    end

    attr_accessor :stages

    def initialize(stages: self.class.default_stages)
      @stages = stages
    end

    def call(objects, options)
      stages.reduce(objects) do |results, filter|
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
