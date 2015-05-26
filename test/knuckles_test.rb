require "test_helper"

class KnucklesTest < Minitest::Test
  parallelize_me!

  def teardown
    Knuckles.reset!
  end

  def test_configured_defaults
    refute_nil Knuckles.json
  end

  def test_configuring_json
    json = Object.new
    Knuckles.json = json
    assert_same json, Knuckles.json
  end

  def test_configuring_knuckles
    json = Object.new

    Knuckles.configure do |knuckles|
      knuckles.json = json
    end

    assert_same json, Knuckles.json
  end
end
