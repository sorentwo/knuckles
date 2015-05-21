require "bundler"

Bundler.setup

require "active_support/cache"
require "minitest/autorun"
require "minitest/reporters"
require "knuckles"
require "support/models"

Minitest::Reporters.use!
