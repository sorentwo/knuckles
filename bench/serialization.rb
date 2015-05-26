require "bundler"

Bundler.setup

require "benchmark/ips"
require "knuckles"

Post = Struct.new(:id, :title, :created_at)

PostSerializer = Class.new(Knuckles::Serializer) do
  root :posts

  attributes :id, :title, :created_at, :updated_at

  def updated_at
    object.created_at
  end
end

pipeline = Knuckles::Pipeline.new
models   = 100.times.map { |i| Post.new(i, "title", Date.new) }

Benchmark.ips do |x|
  x.report("serialize.single") do
    pipeline.call(models, serializer: PostSerializer)
  end
end
