require "test_helper"

class NodeTest < Minitest::Test
  Node  = Knuckles::Node
  Model = Struct.new(:cache_key, :updated_at)

  def test_initializing_accessors
    object = Object.new
    serial = Object.new
    node   = Node.new(object,
      children: [],
      serializer: serial,
      serialized: ''
    )

    assert_equal object, node.object
    assert_equal serial, node.serializer
    assert_equal [],     node.children
    assert_equal '',     node.serialized
  end

  def test_cached_flag
    node = Node.new(Object.new)
    refute node.cached?

    node.cached = true
    assert node.cached?
  end

  def test_cache_key_from_object
    obj   = Model.new('model/123/1234567')
    node  = Node.new(obj)

    assert_equal ['model/123/1234567'], node.cache_key
  end

  def test_cache_key_from_serializer
    ser   = Model.new('custom/123')
    node  = Node.new(Object.new, serializer: ser)

    assert_equal ['custom/123'], node.cache_key
  end

  def test_cache_key_with_a_child
    obj   = Model.new('model/123', Date.new)
    child = Node.new(Model.new('child/456'))
    node  = Node.new(obj, children: [child])

    assert_equal ['model/123', 'child/456'], node.cache_key
  end

  def test_cache_key_with_children
    obj     = Model.new('model/123', Date.new)
    child_a = Node.new(Model.new('child/111', Date.new(2015, 5, 19)))
    child_b = Node.new(Model.new('child/222', Date.new(2015, 5, 20)))
    node    = Node.new(obj, children: [child_a, child_b])

    assert_equal ['model/123', 'child/222'], node.cache_key
  end
end
