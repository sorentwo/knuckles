require "bundler/setup"
require "bundler/gem_tasks"

begin
  require "rspec/core/rake_task"
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

begin
  require "rubocop/rake_task"
  RuboCop::RakeTask.new
rescue LoadError
end

begin
  require "yard"
  YARD::Rake::YardocTask.new
rescue LoadError
end

task default: [:spec, :rubocop]
