require "test_helper"

class KeyStrategyTest < Minitest::Test
  parallelize_me!

  Model = Struct.new(:id, :updated_at)
  Clock = Struct.new(:to_i)

  def test_cache_key_from_object
    object = Model.new(123, Clock.new(1234567))

    assert_equal "KeyStrategyTest::Model/123/1234567/0/", strategy.cache_key(object)
  end

  def test_cache_key_with_a_child
    object = Model.new(123, Clock.new(765))
    child  = Model.new(456, Clock.new(987))

    assert_equal "KeyStrategyTest::Model/123/765/1/987", strategy.cache_key(object, [child])
  end

  def test_cache_key_with_children
    object  = Model.new(123, Clock.new(987))
    child_a = Model.new(111, Time.new(2015, 5, 19))
    child_b = Model.new(222, Time.new(2015, 5, 20))

    assert_match "KeyStrategyTest::Model/123/987/2", strategy.cache_key(object, [child_a, child_b])
  end

  private

  def strategy
    Knuckles::KeyStrategy.new
  end
end
