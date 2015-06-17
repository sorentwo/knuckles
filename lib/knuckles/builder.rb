module Knuckles
  class Builder
    autoload :BuildFilter,     "knuckles/builder/build_filter"
    autoload :ChildrenFilter,  "knuckles/builder/children_filter"
    autoload :SerializeFilter, "knuckles/builder/serialize_filter"

    attr_reader :adapter

    def initialize(adapter = Knuckles::Adapter::Sideload)
      @adapter = adapter
    end

    def call(objects, context = {})
      serializers = wrapped(objects, context.fetch(:serializer))

      instrument('knuckles.filter', {}) do
        adapter.serialize(serializers)
      end
    end

    private

    def wrapped(objects, serializer)
      objects.map { |object| serializer.new(object) }
    end

    def instrument(operation, payload)
      Knuckles.notifications.instrument(operation, payload) do |payload|
        yield payload
      end
    end
  end
end
