module Knuckles
  class Pipeline
    autoload :BuildFilter,     "knuckles/pipeline/build_filter"
    autoload :ChildrenFilter,  "knuckles/pipeline/children_filter"
    autoload :SerializeFilter, "knuckles/pipeline/serialize_filter"
    autoload :WrapFilter,      "knuckles/pipeline/wrap_filter"

    def self.default_filters
      [ WrapFilter,
        ChildrenFilter,
        SerializeFilter,
        BuildFilter ]
    end

    attr_accessor :filters, :notifications

    def initialize(filters = self.class.default_filters)
      @filters = filters.freeze
    end

    def call(objects, context = {})
      filters.reduce(objects) do |object, filter|
        payload = { filter: filter.name, context: context }

        instrument('knuckles.filter', payload) do
          filter.call(object, context)
        end
      end
    end

    private

    def instrument(operation, payload)
      Knuckles.notifications.instrument(operation, payload) do |payload|
        yield payload
      end
    end
  end
end
