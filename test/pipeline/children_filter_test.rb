require "test_helper"

class ChildrenFilterTest < Minitest::Test
  parallelize_me!

  Filter = Knuckles::Pipeline::ChildrenFilter

  def test_extracting_children
    author     = Author.new(1, "Alasdair")
    comment    = Comment.new(1, "Yay", author)
    post       = Post.new(1, "More", author, [comment])
    serializer = PostSerializer.new(post)

    output = Filter.call([serializer])

    assert_equal 3, output.length
    assert_equal [1, 1, 0],
      output.map { |out| out.children.length }
    assert_equal [PostSerializer, CommentSerializer, AuthorSerializer],
      output.map(&:class)
  end
end
