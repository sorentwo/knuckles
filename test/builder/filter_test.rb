require "test_helper"

class FilterTest < Minitest::Test
  parallelize_me!

  Filter = Knuckles::Builder::Filter

  def test_call_raises_implementation_error
    filter = Filter.new([])

    assert_raises(Knuckles::NotImplementedError) { filter.call }
  end
end
