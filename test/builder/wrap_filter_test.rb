require "test_helper"

class WrapFilterTest < Minitest::Test
  parallelize_me!

  Filter     = Knuckles::Builder::WrapFilter
  Serializer = Struct.new(:object)

  def test_wrapping_objects
    output = Filter.call([Object.new], serializer: Serializer)

    assert_equal 1, output.length
    assert_instance_of Serializer, output.first
  end

  def test_serializer_required_in_context
    assert_raises(KeyError) { Filter.call([], {}) }
  end
end
