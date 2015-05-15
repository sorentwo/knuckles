require "test_helper"

class NodeTest < Minitest::Test
  def test_initializing_accessors
    obj  = Object.new
    ser  = Object.new
    node = Knuckles::Node.new(obj,
      serializer: ser,
      dependencies: [],
      serialized: ''
    )

    assert_equal obj, node.object
    assert_equal ser, node.serializer
    assert_equal [],  node.dependencies
    assert_equal '',  node.serialized
  end
end
