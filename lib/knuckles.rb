# frozen_string_literal: true

require "active_support/notifications"
require "active_support/cache"
require "json"

module Knuckles
  autoload :Combiner, "knuckles/combiner"
  autoload :Dumper, "knuckles/dumper"
  autoload :Enhancer, "knuckles/enhancer"
  autoload :Fetcher, "knuckles/fetcher"
  autoload :Hydrator, "knuckles/hydrator"
  autoload :Keygen, "knuckles/keygen"
  autoload :Pipeline, "knuckles/pipeline"
  autoload :Renderer, "knuckles/renderer"
  autoload :View, "knuckles/view"
  autoload :Writer, "knuckles/writer"

  extend self

  attr_writer :cache, :keygen, :notifications, :serializer

  def new(*args)
    Knuckles::Pipeline.new(*args)
  end

  def cache
    @cache ||= ActiveSupport::Cache::MemoryStore.new
  end

  def keygen
    @keygen ||= Knuckles::Keygen
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
    @keygen = nil
    @notifications = nil
    @serializer = nil
  end
end
