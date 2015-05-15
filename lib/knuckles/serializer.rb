module Knuckles
  NullObject = Class.new

  class Serializer < SimpleDelegator
    attr_accessor :object
    attr_writer :dependencies

    def self.includes
      {}
    end

    def self.attributes
      []
    end

    def initialize(object)
      super

      @object = object
    end

    def dependencies
      @dependencies ||= []
    end

    def serialize
      self.class.attributes.each_with_object({}) do |prop, memo|
        memo[prop] = public_send(prop)
      end
    end
  end
end
