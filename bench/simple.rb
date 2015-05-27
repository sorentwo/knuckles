require_relative "./bench_helper"

Knuckles.cache = ActiveSupport::Cache::MemoryStore.new

Post = Struct.new(:id, :title, :created_at)

pipeline = Knuckles::Pipeline.new
models   = 100.times.map { |i| Post.new(i, "title", Date.new) }

Benchmark.ips do |x|
  x.report("serialize.childless") do
    pipeline.call(models, serializer: PostSerializer)
  end
end
