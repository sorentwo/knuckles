require "json"

require "knuckles/relation"
require "knuckles/serializer"
require "knuckles/version"
require "knuckles/builder"
require "knuckles/builder/filter"
require "knuckles/support/notifications"
require "knuckles/support/null_store"

module Knuckles
  NotImplementedError = Class.new(StandardError)

  extend self

  def cache=(cache)
    @cache = cache
  end

  def cache
    @cache ||= Knuckles::Support::NullStore.new
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
    @notifications ||= Knuckles::Support::Notifications.new
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
