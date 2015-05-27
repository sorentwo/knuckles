require_relative "./bench_helper"

Knuckles.cache = ActiveSupport::Cache::MemoryStore.new

pipeline = Knuckles::Pipeline.new
models = BenchHelper.submissions

Benchmark.ips do |x|
  x.report("serialize.realistic") do
    pipeline.call(models, serializer: SubmissionSerializer)
  end
end
