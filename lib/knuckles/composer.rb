require 'set'

module Knuckles
  module Composer
    extend self

    def dependencies(serializers)
      hash = Hash.new { |k, v| k[v] = Set.new }

      serializers.each_with_object(hash) do |serializer, memo|
        serializer.includes.each_key do |key|
          case relation = serializer.object.public_send(key)
          when Array then memo[key] += relation
          when nil   then memo[key]
          else memo[key] << relation
          end
        end
      end
    end
  end
end
