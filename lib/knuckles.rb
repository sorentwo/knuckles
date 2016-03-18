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

  def new(*args)
    Knuckles::Pipeline.new(*args)
  end

  def cache
    @cache ||= ActiveSupport::Cache::MemoryStore.new
  end

  def notifications
    @notifications ||= ActiveSupport::Notifications
  end

  def serializer
    @serializer ||= JSON
  end

  def configure
    yield self
  end

  def reset!
    @cache = nil
    @notifications = nil
    @serializer = nil
  end
end
