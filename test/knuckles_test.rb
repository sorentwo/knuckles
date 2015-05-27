require "test_helper"

class KnucklesTest < Minitest::Test
  parallelize_me!

  def teardown
    Knuckles.reset!
  end

  def test_configured_defaults
    refute_nil Knuckles.json
    refute_nil Knuckles.cache
  end

  def test_configuring_json
    json = Object.new
    Knuckles.json = json
    assert_same json, Knuckles.json
  end

  def test_configuring_knuckles
    json  = Object.new
    cache = Object.new

    Knuckles.configure do |knuckles|
      knuckles.json  = json
      knuckles.cache = cache
    end

    assert_same json,  Knuckles.json
    assert_same cache, Knuckles.cache
  end
end
