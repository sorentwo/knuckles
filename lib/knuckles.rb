require "active_support/notifications"
require "json"

require "knuckles/pipeline"
require "knuckles/renderer"
require "knuckles/view"

module Knuckles
  extend self

  attr_writer :notifications, :serializer

  def notifications
    @notifications ||= ActiveSupport::Notifications
  end

  def serializer
    @serializer ||= JSON
  end

  def render(objects, options = {})
    pipeline = Knuckles::Pipeline.new

    pipeline.call(objects, options)
  end
end
