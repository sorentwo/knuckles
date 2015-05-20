module Knuckles
  class Pipeline
    autoload :CacheFilter,      'knuckles/pipeline/cache_filter'
    autoload :DependencyFilter, 'knuckles/pipeline/dependency_filter'
    autoload :NodeFilter,       'knuckles/pipeline/node_filter'
    autoload :SerializerFilter, 'knuckles/pipeline/serializer_filter'

    def self.notifications
      if Object.const_defined?('ActiveSupport::Notifications')
        ActiveSupport::Notifications
      else
        Knuckles::Notifications
      end
    end

    attr_reader :filters
    attr_accessor :notifications

    def initialize(filters = [])
      @filters       = filters.freeze
      @notifications = self.class.notifications
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
      notifications.instrument(operation, payload) do |payload|
        yield payload
      end
    end
  end
end
