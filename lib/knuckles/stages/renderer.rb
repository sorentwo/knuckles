# frozen_string_literal: true

module Knuckles
  module Stages
    # After un-cached models have been hydrated they can be rendered. Rendering is
    # synonymous with converting a model to a hash, like calling `as_json` on an
    # `ActiveRecord` model. Knuckles provides a minimal (but fast) view module that
    # can be used with the rendering step. Alternatively, if you're migrating from
    # `ActiveModelSerializers` you can pass in an AMS class instead.
    module Renderer
      extend self

      # Serialize all un-cached objects into hashes.
      #
      # @param [Enumerable] prepared The prepared collection to be rendered
      # @option [Module] :view A `Knuckles::View` compliant module,
      #   it will be passed the object and any options. Alternately,
      #   a class compatible with the `ActiveModelSerializers` API.
      #
      # @example Using a Knuckles::View
      #
      #     module PostView
      #       extend Knuckles::View
      #
      #       def self.data(post, _options)
      #         {id: post.id, name: post.name}
      #       end
      #     end
      #
      #     pipeline.call(models, view: PostView)
      #
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
        case view
        when Knuckles::View then view.render(object, options)
        else view.new(object, options).as_json
        end
      end
    end
  end
end
