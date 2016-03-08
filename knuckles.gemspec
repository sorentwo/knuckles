# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'knuckles/version'

Gem::Specification.new do |spec|
  spec.name     = "knuckles"
  spec.version  = Knuckles::VERSION
  spec.authors  = ["Parker Selbert"]
  spec.email    = ["parker@sorentwo.com"]
  spec.summary  = "Simple performance aware data serialization"
  spec.homepage = ""
  spec.license  = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
