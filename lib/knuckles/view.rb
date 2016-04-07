# frozen_string_literal: true

module Knuckles
  # An absolutely bare bones serializer. It is meant as a replacement for
  # `ActiveModelSerializers`, but is entirely focused on being simple and
  # explicit. Views are templates that satisfy the interface of:
  #
  # * root #=> symbol
  # * data #=> hash
  # * relations #=> hash
  #
  # Any object that satisfies that interface can be rendered correctly by the
  # `Renderer` stage.
  #
  # @example Extending for a custom view
  #
  #   module TagView
  #     extend Knuckles::View
  #
  #     def root
  #       :tags
  #     end
  #
  #     def data(tag, _)
  #       {id: tag.id, name: tag.name}
  #     end
  #
  #     def relations(tag, _)
  #       {posts: has_many(tag.posts, PostView)}
  #     end
  #   end
  #
  module View
    extend self

    # Specifies the top level key that data will be stored under. The value
    # will not be stringified or pluralized during rendering, so be aware of
    # the format.
    #
    # @return [Symbol, nil] By default root is `nil`, it should be overridden to
    #   return a plural symbol.
    #
    def root
    end

    # Serialize an object into a hash. This simply returns an empty hash by
    # default, it must be overridden by submodules.
    #
    # @param [Object] _object The object for serializing.
    # @param [Hash] _options The options to be used during serialization, i.e. `:scope`
    #
    # @return [Hash] A hash representing the serialized object.
    #
    # @example Overriding data
    #
    #   module TagView
    #     extend Knuckles::View
    #
    #     def data(tag, _)
    #       {id: tag.id, name: tag.name}
    #     end
    #   end
    #
    def data(_object, _options = {})
      {}
    end

    # Extracts associations for an object. Later these are merged with the
    # output of `data`. View relations are shallow, meaning the relations of
    # relations are not included.
    #
    # @param [Object] _object The object to extract relations from
    # @param [Hash] _options The options used during extraction, i.e. `:scope`
    #
    # @return [Hash] The serialized associations
    #
    # @example Override relations
    #
    #   module PostView
    #     extend Knuckles::View
    #
    #     def relations(post, _)
    #       {author: has_one(post.author, AuthorView),
    #        comments: has_many(post.comments, CommentView)}
    #     end
    #   end
    #
    def relations(_object, _options = {})
      {}
    end

    # Renders an associated object using the specified view, wrapping the
    # results in an array.
    #
    # @param [Object] object The associated object to serialize.
    # @param [Module] view A module responding to `data`.
    # @param [Hash] options Passed to the view for rendering.
    #
    # @return [Array<Hash>] A single rendered data object is always returned.
    #
    # @example Render a single association
    #
    #   PostView.has_one(post.author, AuthorView) #=> [{id: 1, name: "Author"}]
    #
    def has_one(object, view, options = {})
      has_many([object], view, options)
    end

    # Renders all associated objects using the specified view.
    #
    # @param [Array] objects Array of associated objects to serialize.
    # @param [Module] view A module responding to `data`.
    # @param [Hash] options The options passed to the view for rendering.
    #
    # @return [Array<Hash>] All rendered association data.
    #
    # @example Render a single association
    #
    #   PostView.has_one(post.authors, AuthorView) #=> [
    #     {id: 1, name: "Me"},
    #     {id: 2, name: "You"}
    #   ]
    #
    def has_many(objects, view, options = {})
      objects.map { |object| view.data(object, options) }
    end
  end
end
