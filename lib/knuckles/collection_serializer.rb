module Knuckles
  class CollectionSerializer
    attr_reader :collection, :serializer

    def initialize(serializer, collection)
      @serializer = serializer
      @collection = collection
    end

    def serialize
      instance = serializer.new
      mapping  = Hash.new { |hash, key| hash[key] = [] }

      collection.each_with_object(mapping) do |object, memo|
        instance.object = object
        memo[instance.root] << instance.serialize
      end
    end
  end
end
