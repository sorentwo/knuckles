require "test_helper"

class HasOneTest < Minitest::Test
  parallelize_me!

  HasOne = Knuckles::Relation::HasOne

  def test_extracted_id
    author   = Struct.new(:id).new(1)
    model    = Struct.new(:author).new(author)
    relation = HasOne.new(:author, nil)

    assert_equal 1, relation.ids(model)
  end

  def test_attribute_key
    relation = HasOne.new(:author, nil)

    assert_equal :author_id, relation.attribute_key
  end

  def test_associated
    author   = Object.new
    model    = Struct.new(:author).new(author)
    relation = HasOne.new(:author, nil)

    assert_equal author, relation.associated(model)
  end

  def test_serializables_wraps_associated
    author   = Object.new
    options  = Hash.new
    relation = HasOne.new(:author, Knuckles::Serializer)
    model    = Struct.new(:author, :options).new(author, options)

    serializable = relation.serializables(model)

    assert_instance_of Knuckles::Serializer, serializable
    assert_equal author, serializable.object
    assert_equal options, serializable.options
  end
end
