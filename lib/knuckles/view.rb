module Knuckles
  module View
    extend self

    ## Callbacks

    def root
    end

    def data(_object, _options = {})
      {}
    end

    def relations(_object, _options = {})
      {}
    end

    ## Relations

    def has_one(object, view, options = {})
      view.data(object, options)
    end

    def has_many(objects, view, options = {})
      objects.map { |object| view.data(object, options) }
    end
  end
end
