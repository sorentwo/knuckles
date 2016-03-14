module Knuckles
  module Renderer
    extend self

    def name
      "renderer".freeze
    end

    def call(objects, options)
      view = options.fetch(:view)

      objects.each do |hash|
        unless hash[:cached?]
          hash[:result] = do_render(hash[:object], view, options)
        end
      end
    end

    private

    def do_render(object, view, options)
      view.relations(object, options).merge!(
        view.root => [view.data(object, options)]
      )
    end
  end
end
