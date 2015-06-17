module Knuckles
  module Adapter
    class Sideload
      def self.serialize(serializers)
        new(serializers).serialize
      end

      attr_reader :serializers

      def initialize(serializers)
        @serializers = serializers
      end

      def serialize
        filters = [
          Builder::ChildrenFilter,
          Builder::SerializeFilter,
          Builder::BuildFilter
        ]

        filters.reduce(serializers) do |serializer, filter|
          filter.call(serializer)
        end
      end
    end
  end
end
