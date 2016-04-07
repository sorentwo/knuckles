# frozen_string_literal: true

module Knuckles
  # The `Pipeline` is used to transform a collection of objects into a
  # serialized result. A pipeline reduces a collection of objects through a set
  # of stages, passing the result of each stage on to the next. This means that
  # each stage can act in isolation and can compose with new custom stages.
  # Additionally, stages are idividually instrumented for performance
  # monitoring.
  #
  # The `Pipeline` class provides a set of default stages but can be overridden
  # on initialization. Note that after initialization, the stages are frozen to
  # prevent unpredictable mutation.
  class Pipeline
    attr_reader :stages

    # Creates a new instance of `Knuckles::Pipeline`, optionally with custom
    # stages.
    #
    # @option [Array] :stages (default_stages) An array of stages to pipe
    #   results through
    #
    # @example Create a default pipeline
    #
    #   Knuckles::Pipeline.new
    #
    # @example Create a customized pipeline without any caching
    #
    #   Knuckles::Pipeline.new(stages: [
    #     Knuckles::Stages::Renderer,
    #     Knuckles::Stages::Combiner,
    #     Knuckles::Stages::Dumper
    #   ]
    def initialize(stages: default_stages)
      @stages = stages.freeze
    end

    # Provides default stage modules in the intended order. These are the
    # stages that are used if nothing is passed during initialization. The
    # defaults are defined as a method to make overriding with a subclass easy.
    #
    # @example Override `default_stages` within a subclass
    #
    #  class CustomPipeline < Knuckles::Pipeline
    #    def default_stages
    #      [Knuckles::Stages::Renderer,
    #       Knuckles::Stages::Combiner,
    #       Knuckles::Stages::Dumper]
    #    end
    #  end
    #
    def default_stages
      [Knuckles::Stages::Fetcher,
       Knuckles::Stages::Hydrator,
       Knuckles::Stages::Renderer,
       Knuckles::Stages::Writer,
       Knuckles::Stages::Enhancer,
       Knuckles::Stages::Combiner,
       Knuckles::Stages::Dumper]
    end

    # Push a collection of objects through the stages of the pipeline. In
    # normal usage this will render the objects out to a JSON structure.
    #
    # @param [Enumerable] objects A collection of objects (models) to be
    #   serialized and processed.
    # @param [Hash] options The `call` method doesn't use any options itself,
    #   they are forwarded on to each stage. See the documentation for specific
    #   stages for the options they accept.
    #
    # @return [String] The final result as transformed by the pipeline,
    #   typically a JSON string.
    #
    # @example Basic pipeline rendering
    #
    #   pipeline = Knuckles::Pipeline.new
    #   pipeline.call([tag_a, tag_b]) #=> '{"tags":[{"id":1},{"id":2}]}'
    #
    def call(objects, options)
      prepared = prepare(objects)

      stages.reduce(prepared) do |results, stage|
        instrument("knuckles.stage", stage: stage.name) do
          stage.call(results, options)
        end
      end
    end

    # Convert a collection of objects into a collection of hashes that enclose
    # the object. The resulting hashes are populated with the keys and default
    # values necessary for use with the standard pipeline stages.
    #
    # @param [Enumerable] objects A collection of objects to prepare
    #
    # @return [Array[Hash]] An array of hashes, each with the keys `:object`,
    #   `:key`, `:cached?`, and `:result`.
    #
    # @example Prepare a single object
    #
    #   pipeline.prepare([model]) #=> [{object: model, key: nil,
    #                                   cached?: false, result: nil}]
    #
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
