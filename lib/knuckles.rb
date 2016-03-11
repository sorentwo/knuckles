require "json"
require "knuckles/view"
require "knuckles/renderer"

module Knuckles
  extend self

  attr_writer :serializer

  def serializer
    @serializer ||= JSON
  end

  def render(objects, view, options = {})
    Knuckles::Renderer.call(objects, view, options)
  end
end
