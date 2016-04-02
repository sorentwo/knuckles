# frozen_string_literal: true

module Knuckles
  module Enhancer
    extend self

    def call(prepared, options)
      enhancer = options[:enhancer]

      if enhancer
        prepared.each do |hash|
          hash[:result] = enhancer.call(hash[:result], options)
        end
      end

      prepared
    end
  end
end
