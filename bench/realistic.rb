require_relative "./bench_helper"

models = BenchHelper.submissions

Benchmark.ips do |x|
  x.report("serialize.realistic") do
    Knuckles.render_to_string(models, SubmissionView)
  end
end
