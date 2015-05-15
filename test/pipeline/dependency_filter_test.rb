require "test_helper"

class DependencyFilterTest < Minitest::Test
  Filter = Knuckles::Pipeline::DependencyFilter

  PostSerializer = Class.new(Knuckles::Serializer) do
    def self.includes
      { author: Knuckles::Serializer,
        comments: Knuckles::Serializer }
    end
  end

  def test_extracting_dependencies
    post   = Post.new(1, "More")
    author = Author.new(1, "Alasdair")
    comm_a = Comment.new(1, "This is a comment")
    comm_b = Comment.new(2, "That was a comment")

    post.author   = author
    post.comments = [comm_a, comm_b]

    serializer   = PostSerializer.new(post)
    output       = Filter.call([serializer], {})
    dependencies = output.first.dependencies

    assert dependencies.key?(:author)
    assert dependencies.key?(:comments)
    assert_equal 1, dependencies[:author].size
    assert_equal 2, dependencies[:comments].size
  end
end
