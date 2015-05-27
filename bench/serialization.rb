require_relative "./bench_helper"

Knuckles.cache = ActiveSupport::Cache::MemoryStore.new

Post = Struct.new(:id, :title, :created_at)

class PostSerializer < Knuckles::Serializer
  root :posts

  attributes :id, :title, :created_at, :updated_at

  def cache_key
    "posts/#{object.id}"
  end

  def updated_at
    object.created_at
  end
end

pipeline = Knuckles::Pipeline.new
models   = 100.times.map { |i| Post.new(i, "title", Date.new) }

Benchmark.ips do |x|
  x.report("serialize.simple") do
    pipeline.call(models, serializer: PostSerializer)
  end
end
