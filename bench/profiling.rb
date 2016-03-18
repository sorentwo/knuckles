require_relative "./bench_helper"

require "fileutils"
require "stackprof"

FileUtils.mkdir_p("tmp")

models = BenchHelper.submissions

StackProf.run(mode: :wall, interval: 500, out: "tmp/stackprof-wall.dump") do
  100.times do
    Knuckles.new.call(models, view: SubmissionView)
  end
end
