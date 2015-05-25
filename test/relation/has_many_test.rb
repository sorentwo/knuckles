require "test_helper"

class HasManyTest < Minitest::Test
  HasMany = Knuckles::Relation::HasMany

  def test_extracted_id
    comment_a = Comment.new(44)
    comment_b = Comment.new(55)
    model     = Struct.new(:comments).new([comment_a, comment_b])
    relation  = HasMany.new(:comments, nil)

    assert_equal [44, 55], relation.ids(model)
  end

  def test_attribute_key
    relation = HasMany.new(:comments, nil)

    assert_equal :comment_ids, relation.attribute_key
  end

  def test_associated
    comment_a = Comment.new(44)
    comment_b = Comment.new(55)
    model     = Struct.new(:comments).new([comment_a, comment_b])
    relation  = HasMany.new(:comments, nil)

    assert_equal [comment_a, comment_b], relation.associated(model)
  end

  def test_serializables_wraps_each_associated
    comment_a = Comment.new(44)
    comment_b = Comment.new(55)
    model     = Struct.new(:comments).new([comment_a, comment_b])
    relation  = HasMany.new(:comments, Knuckles::Serializer)

    serializables = relation.serializables(model)

    assert_equal 2, serializables.length
    assert_instance_of Knuckles::Serializer, serializables.first
  end
end
