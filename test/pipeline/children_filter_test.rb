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

  def test_extracting_dependencies
    author     = Author.new(1, "Alasdair")
    comment    = Comment.new(1, "Yay", author)
    post       = Post.new(1, "More", author, [comment])
    serializer = PostSerializer.new(post)
    node       = Node.new(post, serializer: serializer)

    output, _ = Filter.call([node])
    child, _  = output.children

    assert_equal 1, output.children.length
    assert_equal output, child.parent
    assert_instance_of CommSerializer, child.serializer

    assert_equal 1, child.children.length
    assert_equal child, child.children.first.parent
  end
end
