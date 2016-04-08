# frozen_string_literal: true

require "active_support/notifications"
require "active_support/cache"
require "json"

# Knuckles is a performance focused data serialization pipeline. More simply,
# it tries to serialize models into large JSON payloads as quickly as possible.
# It operates on a collection of data through stages, passing them through a
# pipeline of transformations.
#
# The default configuration uses `MemoryStore`, but you can configure it along
# with other customizations.
#
# @example Configuration
#
#   Knuckles.configure do |config|
#     config.cache      = Readthis::Cache.new
#     config.keygen     = Readthis::Expanders
#     config.serializer = Oj
#   end
#
# With the module configured you can begin transforming models into JSON (or
# MessagePack, whatever your API uses):
#
# @example Usage with default pipeline
#
#   Knuckles.new.call(models, view: SubmissionView) #=>
#     '{"submissions":[], "tags":[], "responses":[]}'
#
module Knuckles
  autoload :Keygen, "knuckles/keygen"
  autoload :Pipeline, "knuckles/pipeline"
  autoload :View, "knuckles/view"

  module Stages
    autoload :Combiner, "knuckles/stages/combiner"
    autoload :Dumper, "knuckles/stages/dumper"
    autoload :Enhancer, "knuckles/stages/enhancer"
    autoload :Fetcher, "knuckles/stages/fetcher"
    autoload :Hydrator, "knuckles/stages/hydrator"
    autoload :Renderer, "knuckles/stages/renderer"
    autoload :Writer, "knuckles/stages/writer"
  end

  extend self

  attr_writer :cache, :keygen, :notifications, :serializer

  # Convenience method for initializing a new `Pipeline`
  #
  # @see Knuckles::Pipeline#initialize
  #
  def new(*args)
    Knuckles::Pipeline.new(*args)
  end

  # Module accessor for `cache`, defaults to `Cache::MemoryStore`
  #
  # @return [#cache] A cache instance
  #
  def cache
    @cache ||= ActiveSupport::Cache::MemoryStore.new
  end

  # Module accessor `keygen`, defaults to `Knuckles::Keygen`
  #
  # @return [Module] Cache key generation module
  #
  def keygen
    @keygen ||= Knuckles::Keygen
  end

  # Module accessor for `notifications`, defaults to
  # `ActiveSupport::Notifications`
  #
  # @return [Module] Instrumentation module
  #
  def notifications
    @notifications ||= ActiveSupport::Notifications
  end

  # Module accessor for `serializer`, defaults to `JSON`
  #
  # @return [Module] The serializer
  #
  def serializer
    @serializer ||= JSON
  end

  # Convenience for setting properties as within a block
  #
  # @example Configuring knuckles
  #
  #   Knuckles.configure do |config|
  #     config.serializer = MessagePack
  #   end
  #
  def configure
    yield self
  end

  # @private
  def reset!
    @cache = nil
    @keygen = nil
    @notifications = nil
    @serializer = nil
  end
end
