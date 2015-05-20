require "test_helper"

class CacheFilterTest < Minitest::Test
  Filter = Knuckles::Pipeline::CacheFilter
  Model  = Struct.new(:cache_key)

  def test_serialized_values_inserted_when_cached
    node_a = Knuckles::Node.new(Model.new('model/1'))
    node_b = Knuckles::Node.new(Model.new('model/2'))
    node_c = Knuckles::Node.new(Model.new('model/3'))
    cache  = MemoryStore.new
    filter = Filter.new([node_a, node_b, node_c])

    filter.cache = cache

    cache.write('model/1', '{"thing":1}')
    cache.write('model/3', '{"thing":3}')

    output = filter.call

    refute_nil output[0].serialized
    assert_nil output[1].serialized
    refute_nil output[2].serialized

    assert_equal ['{"thing":1}', nil, '{"thing":3}'], output.map(&:serialized)
  end
end
