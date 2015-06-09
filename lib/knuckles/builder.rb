module Knuckles
  class Builder
    autoload :BuildFilter,     "knuckles/builder/build_filter"
    autoload :ChildrenFilter,  "knuckles/builder/children_filter"
    autoload :SerializeFilter, "knuckles/builder/serialize_filter"
    autoload :WrapFilter,      "knuckles/builder/wrap_filter"

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
