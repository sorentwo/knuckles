require "test_helper"

class SerializerTest < Minitest::Test
  def test_serializing_an_object
    serializer = Class.new(Knuckles::Serializer) do
      def self.attributes
        %i[id title]
      end
    end

    post = Post.new(100, "Knuckles")
    serialized = serializer.new(post).serialize

    assert_equal({ id: 100, title: "Knuckles" }, serialized)
  end

  def test_overriding_properties
    serializer = Class.new(Knuckles::Serializer) do
      def self.attributes
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

  def test_to_json_stringifies_serialized_output
    serializer = Class.new(Knuckles::Serializer) do
      def self.attributes
        %i[id title]
      end
    end

    post = Post.new(100, "Knuckles")
    json = serializer.new(post).to_json

    assert_equal '{"id":100,"title":"Knuckles"}', json
  end
end
