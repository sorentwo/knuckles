module Knuckles
  module Renderer
    extend self

    def name
      "renderer".freeze
    end

    def call(objects, options)
      view = options.fetch(:view)

      objects.each do |hash|
        next if hash[:cached]

        memo = array_backed_hash
        memo[view.root] << view.data(hash[:object], options)

        view.relations(hash[:object], options).each do |root, data|
          memo[root] += data
        end

        hash[:result] = memo
      end
    end

    private

    def array_backed_hash
      Hash.new { |hash, key| hash[key] = [] }
    end
  end
end
