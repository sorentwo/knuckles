require "bundler"

Bundler.setup

require "active_support/cache"
require "benchmark/ips"
require "json"
require "knuckles"
require_relative "fixtures/serializers"

class BenchModel
  attr_reader :key

  def initialize(key, attributes)
    attributes.each do |key, value|
      self.class.send(:define_method, key) { value }
    end
  end

  def cache_key
    "#{key}/#{id}/#{updated_at}"
  end
end

module BenchHelper
  extend self

  def submissions
    mapping = %w[scout responses tags]
    loaded  = JSON.load(IO.read("bench/fixtures/submissions.json"))

    loaded.map do |object|
      mapping.each do |key|
        object[key] = structify(key, object[key])
      end

      structify('submissions', object)
    end
  end

  def structify(key, object)
    if object.is_a?(Array)
      object.map { |obj| BenchModel.new(key, obj) }
    else
      BenchModel.new(key, object)
    end
  end
end
