require_relative "./bench_helper"

require "fileutils"
require "stackprof"

FileUtils.mkdir_p("tmp")

models = BenchHelper.submissions

StackProf.run(mode: :cpu, interval: 500, out: "tmp/stackprof-cpu.dump") do
  100.times do
    Knuckles.render_to_string(models, SubmissionView)
  end
end
