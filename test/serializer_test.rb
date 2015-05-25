require "test_helper"

class SerializerTest < Minitest::Test
  Serializer = Knuckles::Serializer
  Model      = Struct.new(:id, :cache_key, :updated_at)

  def test_initializing_accessors
    object   = Object.new
    instance = Serializer.new(object, children: [])

    assert_equal object, instance.object
    assert_equal [],     instance.children
  end

  def test_cached_predicate
    instance = Serializer.new(Object.new)
    refute instance.cached?

    instance.serialized = '{}'
    assert instance.cached?
  end

  def test_defining_a_root
    klass = Class.new(Serializer) do
      root :things
    end

    assert_equal :things, klass.new(nil).root
  end

  def test_defining_attributes
    klass = Class.new(Serializer) do
      attributes :id, :name, :date
    end

    model    = Struct.new(:id, :name, :date).new(1, 'hi', Date.new)
    instance = klass.new(model)

    assert_equal %i[id name date], instance.attributes
    assert_equal model.id,   instance.id
    assert_equal model.name, instance.name
    assert_equal model.date, instance.date
  end

  def test_serializing_an_object
    serializer = Class.new(Serializer) do
      attributes :id, :title
    end

    post = Post.new(100, "Knuckles")
    serialized = serializer.new(post).as_json

    assert_equal({ id: 100, title: "Knuckles" }, serialized)
  end

  def test_overriding_properties
    serializer = Class.new(Serializer) do
      attributes :id, :title

      def title
        object.title.capitalize
      end
    end

    post = Post.new(100, "KNUCKLES")
    serialized = serializer.new(post).as_json

    assert_equal "Knuckles", serialized[:title]
  end

  def test_serializing_without_attributes
    post = Post.new(100, "Knuckles")
    serializer = Serializer.new(post)

    assert_equal({}, serializer.as_json)
  end

  def test_serializing_child_ids
    serializer = Class.new(Serializer) do
      def self.includes
        { comments: Serializer }
      end

      def comments
        [Model.new(111), Model.new(222)]
      end
    end

    instance = serializer.new(Model.new)

    assert_equal({
      comment_ids: [111, 222]
    }, instance.as_json)
  end

  def test_to_json_stringifies_serialized_output
    serializer = Class.new(Serializer) do
      attributes :id, :title
    end

    post = Post.new(100, "Knuckles")
    json = serializer.new(post).to_json

    assert_equal '{"id":100,"title":"Knuckles"}', json
  end

  def test_cache_key_from_object
    object   = Model.new(123, 'model/123/1234567')
    instance = Serializer.new(object)

    assert_equal ['model/123/1234567'], instance.cache_key
  end

  def test_cache_key_with_a_child
    object   = Model.new(123, "model/123", Date.new)
    child    = Model.new(456, "child/456")
    instance = Serializer.new(object, children: [child])

    assert_equal ["model/123", "child/456"], instance.cache_key
  end

  def test_cache_key_with_children
    object   = Model.new(123, "model/123", Date.new)
    child_a  = Model.new(111, "child/111", Date.new(2015, 5, 19))
    child_b  = Model.new(222, "child/222", Date.new(2015, 5, 20))
    instance = Serializer.new(object, children: [child_a, child_b])

    assert_equal ["model/123", "child/222"], instance.cache_key
  end
end
