require "test_helper"

class SerializeFilterTest < Minitest::Test
  parallelize_me!

  Filter     = Knuckles::Builder::SerializeFilter
  Serializer = Knuckles::Serializer

  Post = Struct.new(:id, :title)

  PostSerializer = Class.new(Serializer) do
    attributes :id, :title

    def cache_key
      "posts/#{id}"
    end
  end

  def setup
    Knuckles.cache = cache
  end

  def teardown
    Knuckles.reset!
  end

  def test_serialized_values_inserted_when_cached
    inst_a = PostSerializer.new(Post.new(1, "a"))
    inst_b = PostSerializer.new(Post.new(2, "b"))
    inst_c = PostSerializer.new(Post.new(3, "c"))

    cache.write("posts/1", '{"thing":1}')
    cache.write("posts/3", '{"thing":3}')

    output = Filter.call([inst_a, inst_b, inst_c])

    assert_equal [
      '{"thing":1}',
      '{"id":2,"title":"b"}',
      '{"thing":3}'
    ], output.map(&:serialized)
  end

  def test_serialization_is_stored
    post       = Post.new(1, "More")
    serializer = PostSerializer.new(post)

    output, _ = Filter.call([serializer])

    refute_nil output.serialized
    assert_equal '{"id":1,"title":"More"}', output.serialized
  end

  private

  def cache
    @cache ||= ActiveSupport::Cache::MemoryStore.new
  end
end
