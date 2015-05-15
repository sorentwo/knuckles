module Knuckles
  class Pipeline
    autoload :SerializerFilter, 'knuckles/pipeline/serializer_filter'

    attr_reader :filters

    def initialize(filters = [])
      @filters = filters.freeze
    end

    def call(objects, context = {})
      filters.reduce(objects) do |serialized, filter|
        filter.call(serialized, context)
      end
    end
  end
end
