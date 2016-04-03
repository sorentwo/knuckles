# frozen_string_literal: true

module Knuckles
  # The Keygen module provides simple cache key generation. The global keygen
  # strategy can be changed at the top level by configuring `Knuckles.keygen`.
  #
  # Any object that responds to `expand_key` with a single argument can be
  # used instead.
  #
  # @example Change global keygen stragey
  #
  #   Knuckles.keygen = MyCustomKeygen.new
  #
  module Keygen
    extend self

    # Calculates a cache key for the given object. It first attempts to use
    # the object's `cache_key` method (present on `ActiveRecord` models). It
    # falls back to combining the object's `id` and `updated_at` values.
    #
    # @param [Object] Object to caclculate key for
    #
    # @return [String] Computed cache key
    #
    # @example
    #
    #   Knuckles::Keygen.expand_key(model) #=> "MyModel/1/1234567890"
    #
    def expand_key(object)
      if object.respond_to?(:cache_key)
        object.cache_key
      else
        "#{object.class.name}/#{object.id}/#{object.updated_at.to_i}"
      end
    end
  end
end
