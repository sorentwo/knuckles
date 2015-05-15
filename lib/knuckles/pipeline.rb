module Knuckles
  class Pipeline
    autoload :DependencyFilter, 'knuckles/pipeline/dependency_filter'
    autoload :NodeFilter,       'knuckles/pipeline/node_filter'
    autoload :SerializerFilter, 'knuckles/pipeline/serializer_filter'

    attr_reader :filters

    def initialize(filters = [])
      @filters = filters.freeze
    end

    def call(objects, context = {})
      filters.reduce(objects) do |object, filter|
        filter.call(object, context)
      end
    end
  end
end
