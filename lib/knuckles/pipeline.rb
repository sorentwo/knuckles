module Knuckles
  class Pipeline
    attr_reader :filters

    def initialize(filters = [])
      @filters = filters
    end

    def call(objects, context = {})
      filters.reduce(objects) do |serialized, filter|
        filter.call(serialized, context)
      end
    end
  end
end
