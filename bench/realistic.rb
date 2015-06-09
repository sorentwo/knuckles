require_relative "./bench_helper"

Knuckles.cache = ActiveSupport::Cache::MemoryStore.new

builder = Knuckles::Builder.new
models = BenchHelper.submissions

Benchmark.ips do |x|
  x.report("serialize.realistic") do
    builder.call(models, serializer: SubmissionSerializer)
  end
end
