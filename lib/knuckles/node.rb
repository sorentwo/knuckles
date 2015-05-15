module Knuckles
  class Node
    attr_reader :object
    attr_accessor :serializer, :dependencies, :serialized

    def initialize(object, serializer: nil, dependencies: nil, serialized: nil)
      @object       = object
      @serializer   = serializer
      @dependencies = dependencies
      @serialized   = serialized
    end
  end
end
