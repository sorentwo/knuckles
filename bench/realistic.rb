require_relative "./bench_helper"

models = BenchHelper.submissions

Benchmark.ips do |x|
  x.report("serialize.realistic") do
    Knuckles.new.call(models, view: SubmissionView)
  end
end
