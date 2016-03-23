require "set"

module Knuckles
  module Combiner
    extend self

    def name
      "combiner".freeze
    end

    def call(prepared, _)
      prepared.each_with_object(array_backed_hash) do |hash, memo|
        hash[:result].each do |root, values|
          case values
          when Hash  then memo[root] << values
          when Array then memo[root] += values
          end
        end
      end
    end

    def array_backed_hash
      Hash.new { |hash, key| hash[key] = [] }
    end
  end
end
