require "json"

require "knuckles/notifications"
require "knuckles/pipeline/filter"
require "knuckles/pipeline"
require "knuckles/serializer"
require "knuckles/version"

module Knuckles
  NotImplementedError = Class.new(StandardError)

  extend self

  def json=(json)
    @json = json
  end

  def json
    @json ||= JSON
  end

  def configure
    yield self
  end

  def reset!
    @json = nil
  end
end
