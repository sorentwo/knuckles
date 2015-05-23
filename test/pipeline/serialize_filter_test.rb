require "test_helper"

class SerializeFilterTest < Minitest::Test
  Filter = Knuckles::Pipeline::SerializeFilter

  PostSerializer = Class.new(Knuckles::Serializer) do
    def self.attributes
      %i[id title]
    end
  end

  def test_serialization_is_stored
    post       = Post.new(1, "More")
    serializer = PostSerializer.new(post)

    output, _ = Filter.call([serializer])

    refute_nil output.serialized
    assert_equal '{"id":1,"title":"More"}', output.serialized
  end

  def test_serialized_values_are_not_overwritten
    post       = Post.new(1, "Updated")
    serializer = PostSerializer.new(post, serialized: '{}')

    output, _ = Filter.call([serializer])

    assert_equal '{}', output.serialized
  end
end
