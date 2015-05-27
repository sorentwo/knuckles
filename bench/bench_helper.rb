require "bundler"

Bundler.setup

require "active_support/cache"
require "benchmark/ips"
require "ostruct"
require "json"
require "knuckles"
require_relative "fixtures/serializers"

module BenchHelper
  extend self

  def submissions
    mapping = %w[scout responses tags]
    loaded  = JSON.load(IO.read("bench/fixtures/submissions.json"))

    loaded.map do |object|
      mapping.each do |key|
        object[key] = structify(object[key])
      end

      structify(object)
    end
  end

  def structify(object)
    if object.is_a?(Array)
      object.map { |obj| OpenStruct.new(obj) }
    else
      OpenStruct.new(object)
    end
  end
end
