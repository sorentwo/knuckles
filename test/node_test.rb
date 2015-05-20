require "test_helper"

class NodeTest < Minitest::Test
  Model = Struct.new(:cache_key, :updated_at)

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

  def test_cache_key_from_object
    obj   = Model.new('model/123/1234567')
    node  = Knuckles::Node.new(obj)

    assert_equal ['model/123/1234567'], node.cache_key
  end

  def test_cache_key_from_serializer
    ser   = Model.new('custom/123')
    node  = Knuckles::Node.new(Object.new, serializer: ser)

    assert_equal ['custom/123'], node.cache_key
  end

  def test_cache_key_with_a_dependency
    obj   = Model.new('model/123', Date.new)
    child = Model.new('child/456')
    node  = Knuckles::Node.new(obj, dependencies: {
      children: Set.new([child])
    })

    assert_equal ['model/123', 'child/456'], node.cache_key
  end

  def test_cache_key_with_dependencies
    obj     = Model.new('model/123', Date.new)
    child_a = Model.new('child/111', Date.new(2015, 5, 19))
    child_b = Model.new('child/222', Date.new(2015, 5, 20))
    node    = Knuckles::Node.new(obj, dependencies: {
      children: Set.new([child_a, child_b])
    })

    assert_equal ['model/123', 'child/222'], node.cache_key
  end
end
