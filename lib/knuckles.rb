require "json"

require "knuckles/notifications"
require "knuckles/builder/filter"
require "knuckles/builder"
require "knuckles/relation"
require "knuckles/serializer"
require "knuckles/version"

module Knuckles
  NotImplementedError = Class.new(StandardError)

  extend self

  def cache=(cache)
    @cache = cache
  end

  # TODO: Remove implicit dependency on `ActiveSupport` here
  def cache
    @cache ||= ActiveSupport::Cache::NullStore.new
  end

  def json=(json)
    @json = json
  end

  def json
    @json ||= JSON
  end

  def notifications=(notifications)
    @notifications = notifications
  end

  def notifications
    @notifications ||= Knuckles::Notifications
  end

  def configure
    yield self
  end

  def reset!
    @json          = nil
    @cache         = nil
    @notifications = nil
  end
end
