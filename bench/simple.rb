require_relative "./bench_helper"

Knuckles.cache = ActiveSupport::Cache::MemoryStore.new

Post = Struct.new(:id, :title, :updated_at)

class PostSerializer < Knuckles::Serializer
  root :posts

  attributes :id, :title, :updated_at
end

builder = Knuckles::Builder.new
models  = 100.times.map { |i| Post.new(i, "title", Time.new) }

Benchmark.ips do |x|
  x.report("serialize.main") do
    builder.call(models, serializer: PostSerializer)
  end
end
