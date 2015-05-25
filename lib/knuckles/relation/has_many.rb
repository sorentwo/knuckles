module Knuckles
  module Relation
    class HasMany
      attr_reader :key, :serializer

      def initialize(key, serializer)
        @key        = key
        @serializer = serializer
      end

      def ids(object)
        associated(object).map(&:id)
      end

      def associated(object)
        object.public_send(key)
      end

      def serializables(object)
        associated(object).map do |associate|
          serializer.new(associate)
        end
      end

      def attribute_key
        "#{key.to_s.sub(/s$/, '')}_ids".to_sym
      end
    end
  end
end
