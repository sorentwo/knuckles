require "bundler"

Bundler.setup

require "minitest/autorun"
require "minitest/reporters"
require "knuckles"
require "support/models"

Minitest::Reporters.use!
