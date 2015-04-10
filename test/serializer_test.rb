require "test_helper"

class SerializerTest < Minitest::Test
  Post = Struct.new(:id, :title)

  def test_serializing_an_object
    serializer = Class.new(Knuckles::Serializer) do
      def attributes
        %i[id title]
      end
    end

    post = Post.new(100, "Knuckles")
    serialized = serializer.new(post).serialize

    assert_equal serialized, { id: 100, title: "Knuckles" }
  end

  def test_overriding_properties
    serializer = Class.new(Knuckles::Serializer) do
      def attributes
        %i[id title]
      end

      def title
        object.title.capitalize
      end
    end

    post = Post.new(100, "KNUCKLES")
    serialized = serializer.new(post).serialize

    assert_equal "Knuckles", serialized[:title]
  end

  def test_serializing_without_attributes
    post = Post.new(100, "Knuckles")
    serializer = Knuckles::Serializer.new(post)

    assert_equal({}, serializer.serialize)
  end

  def test_serializing_without_an_object
    serializer = Knuckles::Serializer.new

    assert_equal({}, serializer.serialize)
  end
end
