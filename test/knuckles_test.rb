require "test_helper"

class KnucklesTest < Minitest::Test
  parallelize_me!

  def teardown
    Knuckles.reset!
  end

  def test_configured_defaults
    refute_nil Knuckles.json
    refute_nil Knuckles.cache
    refute_nil Knuckles.notifications
  end

  def test_configuring_knuckles
    json  = Object.new
    cache = Object.new
    notes = Object.new

    Knuckles.configure do |knuckles|
      knuckles.json  = json
      knuckles.cache = cache
      knuckles.notifications = notes
    end

    assert_same json,  Knuckles.json
    assert_same cache, Knuckles.cache
    assert_same notes, Knuckles.notifications
  end
end
