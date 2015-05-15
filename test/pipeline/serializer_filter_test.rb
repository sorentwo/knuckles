require "test_helper"

class SerializerFilterTest < Minitest::Test
  Filter = Knuckles::Pipeline::SerializerFilter

  def test_objects_are_wrapped_in_a_serializer
    serializer = Struct.new(:node)
    context = { serializer: serializer }
    output  = Filter.call([Object.new], context)

    assert_equal 1, output.length
    assert_instance_of serializer, output.first
  end
end
