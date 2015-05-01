require "test_helper"

class ComposerTest < Minitest::Test
  PostSerializer = Class.new(Knuckles::Serializer) do
    def includes
      { author: Knuckles::Serializer, comments: Knuckles::Serializer }
    end
  end

  def test_extracting_dependencies
    post   = Post.new(1, "More")
    author = Author.new(1, "Alasdair")
    comm_a = Comment.new(1, "This is a comment")
    comm_b = Comment.new(2, "That was a comment")

    post.author   = author
    post.comments = [comm_a, comm_b]

    serializer = PostSerializer.new(post)

    assert_equal({
      author: Set.new([author]),
      comments: Set.new([comm_a, comm_b])
    }, Knuckles::Composer.dependencies([serializer]))
  end

  def test_dependencies_are_deduplicated
    post_a = Post.new(1, "More")
    post_b = Post.new(2, "More")
    author = Author.new(1, "Alasdair")

    post_a.author = author
    post_b.author = author

    serializers = [PostSerializer.new(post_a), PostSerializer.new(post_b)]

    assert_equal({
      author: Set.new([author]),
      comments: Set.new([])
    }, Knuckles::Composer.dependencies(serializers))
  end
end
