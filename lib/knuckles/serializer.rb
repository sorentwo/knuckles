module Knuckles
  NullObject = Class.new

  class Serializer
    attr_accessor :object

    def initialize(object = NullObject)
      @object = object
    end

    def attributes
      []
    end

    def serialize
      attributes.each_with_object({}) do |prop, memo|
        receiver = respond_to?(prop) ? self : object
        memo[prop] = receiver.public_send(prop)
      end
    end
  end
end
