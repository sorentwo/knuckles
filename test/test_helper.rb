require "bundler"

Bundler.setup

require "active_support/cache"
require "minitest/autorun"
require "minitest/reporters"
require "knuckles"
require "fixtures/models"
require "fixtures/serializers"

Minitest::Reporters.use!
