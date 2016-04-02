# frozen_string_literal: true

module Knuckles
  module Stages
    module Renderer
      extend self

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
end
