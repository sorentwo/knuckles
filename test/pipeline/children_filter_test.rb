require "test_helper"

class ChildrenFilterTest < Minitest::Test
  Filter = Knuckles::Pipeline::ChildrenFilter
  Node   = Knuckles::Node

  AuthSerializer = Class.new(Knuckles::Serializer)

  CommSerializer = Class.new(Knuckles::Serializer) do
    def self.includes
      { author: AuthSerializer }
    end
  end

  PostSerializer = Class.new(Knuckles::Serializer) do
    def self.includes
      { comments: CommSerializer }
    end
  end

  def test_extracting_children
    author     = Author.new(1, "Alasdair")
    comment    = Comment.new(1, "Yay", author)
    post       = Post.new(1, "More", author, [comment])
    serializer = PostSerializer.new(post)
    node       = Node.new(post, serializer: serializer)

    output = Filter.call([node])

    assert_equal 3, output.length
    assert_equal [1, 1, 0],
      output.map { |out| out.children.length }
    assert_equal [PostSerializer, CommSerializer, AuthSerializer],
      output.map { |out| out.serializer.class }
  end
end
