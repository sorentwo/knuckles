require "test_helper"

class FilterTest < Minitest::Test
  Filter = Knuckles::Pipeline::Filter

  def test_call_raises_implementation_error
    filter = Filter.new([])

    assert_raises(Knuckles::NotImplementedError) { filter.call }
  end
end
