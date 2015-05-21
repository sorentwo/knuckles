require "test_helper"

class SerializeFilterTest < Minitest::Test
  Filter = Knuckles::Pipeline::SerializeFilter

  PostSerializer = Class.new(Knuckles::Serializer) do
    def self.attributes
      %i[id title]
    end
  end

  def test_nodes_are_serialized
    post       = Post.new(1, "More")
    serializer = PostSerializer.new(post)
    node       = Knuckles::Node.new(post, serializer: serializer)

    output, _ = Filter.call([node])

    refute_nil output.serialized
    assert_equal '{"id":1,"title":"More"}', output.serialized
  end

  def test_serialized_values_are_not_overwritten
    post       = Post.new(1, "Updated")
    serializer = PostSerializer.new(post)
    node       = Knuckles::Node.new(post, serialized: '{}', serializer: serializer)

    output, _ = Filter.call([node])

    assert_equal '{}', output.serialized
  end
end
