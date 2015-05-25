require "test_helper"

class CacheFilterTest < Minitest::Test
  Filter     = Knuckles::Pipeline::CacheFilter
  Model      = Struct.new(:cache_key)
  Serializer = Knuckles::Serializer

  def test_serialized_values_inserted_when_cached
    inst_a = Serializer.new(Model.new('model/1'))
    inst_b = Serializer.new(Model.new('model/2'))
    inst_c = Serializer.new(Model.new('model/3'))
    cache  = ActiveSupport::Cache::MemoryStore.new
    filter = Filter.new([inst_a, inst_b, inst_c])

    filter.cache = cache

    cache.write("model/1", '{"thing":1}')
    cache.write("model/3", '{"thing":3}')

    output = filter.call

    assert_equal ['{"thing":1}', nil, '{"thing":3}'], output.map(&:serialized)
    assert_equal [true, false, true], output.map(&:cached?)
  end
end
