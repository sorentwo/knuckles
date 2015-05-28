require_relative "./bench_helper"

require "fileutils"
require "stackprof"

FileUtils.mkdir_p("tmp")

pipeline = Knuckles::Pipeline.new
models   = BenchHelper.submissions

StackProf.run(mode: :cpu, interval: 500, out: "tmp/stackprof-cpu.dump") do
  10.times do
    pipeline.call(models, serializer: SubmissionSerializer)
  end
end
