require "test_helper"

class NodeFilterTest < Minitest::Test
  Filter = Knuckles::Pipeline::NodeFilter

  def test_wrapping_objects
    output = Filter.call([Object.new])

    assert_equal 1, output.length
    assert_instance_of Knuckles::Node, output.first
  end
end
