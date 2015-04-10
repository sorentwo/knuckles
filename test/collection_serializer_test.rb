require "test_helper"

class CollectionSerializerTest < Minitest::Test
  Post = Struct.new(:id, :title)

  def test_serializing_multiple_objects
    enumerable = [Post.new(1, "Grass"), Post.new(2, "Woods")]
    serializer = Class.new(Knuckles::Serializer) do
      def root
        :posts
      end

      def attributes
        %i[id title]
      end
    end

    serializer = Knuckles::CollectionSerializer.new(serializer, enumerable)

    assert_equal({ posts: [
      { id: 1, title: "Grass" },
      { id: 2, title: "Woods" }
    ]}, serializer.serialize)
  end
end
