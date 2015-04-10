class EnumSerializer
  include Enumerable

  attr_reader :collection, :serializer

  def initialize(serializer, collection)
    @serializer = serializer
    @collection = collection
  end

  def each
    collection.map { |object| serializer.serialize(object) }
  end
end
