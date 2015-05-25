module Knuckles
  module Relation
    class HasOne
      attr_reader :key, :serializer

      def initialize(key, serializer)
        @key        = key
        @serializer = serializer
      end

      def ids(parent)
        associated(parent).id
      end

      def associated(parent)
        parent.public_send(key)
      end

      def serializables(parent)
        serializer.new(associated(parent), parent.options)
      end

      def attribute_key
        "#{key.to_s}_id".to_sym
      end
    end
  end
end
