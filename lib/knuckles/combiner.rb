require "set"

module Knuckles
  module Combiner
    extend self

    def name
      "combiner".freeze
    end

    def call(prepared, _)
      prepared.each_with_object(set_backed_hash) do |hash, memo|
        hash[:result].each { |root, values| memo[root] += values }
      end
    end

    def set_backed_hash
      Hash.new { |hash, key| hash[key] = Set.new }
    end
  end
end
