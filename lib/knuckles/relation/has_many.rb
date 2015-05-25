module Knuckles
  module Relation
    class HasMany
      attr_reader :key, :serializer

      def initialize(key, serializer)
        @key        = key
        @serializer = serializer
      end

      def ids(parent)
        associated(parent).map(&:id)
      end

      def associated(parent)
        parent.public_send(key)
      end

      def serializables(parent)
        associated(parent).map do |associate|
          serializer.new(associate, parent.options)
        end
      end

      def attribute_key
        "#{key.to_s.sub(/s$/, '')}_ids".to_sym
      end
    end
  end
end
