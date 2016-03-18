require "active_support/notifications"
require "active_support/cache"
require "json"

require "knuckles/combiner"
require "knuckles/dumper"
require "knuckles/fetcher"
require "knuckles/hydrator"
require "knuckles/pipeline"
require "knuckles/renderer"
require "knuckles/writer"
require "knuckles/view"

module Knuckles
  extend self

  attr_writer :cache, :notifications, :serializer

  def cache
    @cache ||= ActiveSupport::Cache::MemoryStore.new
  end

  def notifications
    @notifications ||= ActiveSupport::Notifications
  end

  def serializer
    @serializer ||= JSON
  end

  def reset!
    @cache = nil
    @notifications = nil
    @serializer = nil
  end

  def render(objects, options = {})
    pipeline = Knuckles::Pipeline.new

    pipeline.call(objects, options)
  end

  def prepare(objects)
    objects.map do |object|
      {object: object, key: nil, cached?: false, result: nil}
    end
  end
end
