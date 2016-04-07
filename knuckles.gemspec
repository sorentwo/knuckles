# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "knuckles/version"

Gem::Specification.new do |spec|
  spec.name     = "knuckles"
  spec.version  = Knuckles::VERSION
  spec.authors  = ["Parker Selbert"]
  spec.email    = ["parker@sorentwo.com"]
  spec.summary  = "Simple performance aware data serialization"
  spec.homepage = "https://github.com/sorentwo/knuckles"
  spec.license  = "MIT"

  doc_files = "CHANGELOG.md LICENSE.txt README.md"

  spec.files         = `git ls-files -z lib spec #{doc_files}`.split("\x0")
  spec.executables   = []
  spec.test_files    = spec.files.grep(%r{^spec/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "> 4.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
