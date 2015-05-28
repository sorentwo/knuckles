require_relative "./bench_helper"

Knuckles.cache = ActiveSupport::Cache::MemoryStore.new

Post = Struct.new(:id, :title, :created_at)

class PostSerializer < Knuckles::Serializer
  root :posts

  attributes :id, :title, :created_at

  def cache_key
    "posts/#{id}"
  end
end

pipeline = Knuckles::Pipeline.new
models   = 100.times.map { |i| Post.new(i, "title", Date.new) }

Benchmark.ips do |x|
  x.report("serialize.childless") do
    pipeline.call(models, serializer: PostSerializer)
  end
end
