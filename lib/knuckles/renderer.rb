require "set"

module Knuckles
  module Renderer
    extend self

    def call(objects, options)
      view = options.fetch(:view)

      objects.each_with_object(set_backed_hash) do |object, memo|
        memo[view.root] << view.data(object, options)

        view.relations(object, options).each do |root, data|
          memo[root] += data
        end
      end
    end

    private

    def set_backed_hash
      Hash.new { |hash, key| hash[key] = Set.new }
    end
  end
end
