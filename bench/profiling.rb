require_relative "./bench_helper"

require "fileutils"
require "stackprof"

FileUtils.mkdir_p("tmp")

builder = Knuckles::Builder.new
models  = BenchHelper.submissions

StackProf.run(mode: :cpu, interval: 500, out: "tmp/stackprof-cpu.dump") do
  100.times do
    builder.call(models, serializer: SubmissionSerializer)
  end
end
