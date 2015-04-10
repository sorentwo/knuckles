require "test_helper"

class Knuckles::SerializerTest < Minitest::Test
  Post = Struct.new(:id, :title)

  def test_serializing_without_attributes
    serializer = Knuckles::Serializer.new
    post = Post.new(100, "Knuckles")

    assert_equal serializer.serialize(post), {}
  end

  def test_serializing_an_object
    serializer = Class.new(Knuckles::Serializer) do
      def attributes
        %i[id title]
      end
    end

    post = Post.new(100, "Knuckles")
    serialized = serializer.new.serialize(post)

    assert_equal serialized, { id: 100, title: "Knuckles" }
  end

  def test_overriding_properties
    serializer = Class.new(Knuckles::Serializer) do
      def attributes
        %i[id title]
      end

      def title(object)
        object.title.capitalize
      end
    end

    post = Post.new(100, "KNUCKLES")
    serialized = serializer.new.serialize(post)

    assert_equal "Knuckles", serialized[:title]
  end
end
