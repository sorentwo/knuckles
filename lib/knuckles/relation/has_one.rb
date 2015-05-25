module Knuckles
  module Relation
    class HasOne
      attr_reader :key, :serializer

      def initialize(key, serializer)
        @key        = key
        @serializer = serializer
      end

      def ids(object)
        associated(object).id
      end

      def associated(object)
        object.public_send(key)
      end

      def serializables(object)
        serializer.new(associated(object))
      end

      def attribute_key
        "#{key.to_s}_id".to_sym
      end
    end
  end
end
