require "test_helper"

class SerializerFilterTest < Minitest::Test
  Filter = Knuckles::Pipeline::SerializerFilter

  def test_objects_are_wrapped_in_a_serializer
    serializer = Struct.new(:node)
    node       = Knuckles::Node.new(Object.new)
    output     = Filter.call([node], serializer: serializer)

    assert_equal 1, output.length
    assert_instance_of Knuckles::Node, output.first
    assert_instance_of serializer, output.first.serializer
  end

  def test_serializer_required_in_context
    assert_raises(KeyError) { Filter.call([], {}) }
  end
end
