require "set"

module Knuckles
  module Renderer
    extend self

    def name
      "renderer".freeze
    end

    def call(objects, options)
      view = options.fetch(:view)

      objects.each_with_object(set_backed_hash) do |hash, memo|
        memo[view.root] << view.data(hash[:object], options)

        view.relations(hash[:object], options).each do |root, data|
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
