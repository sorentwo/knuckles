require "test_helper"

class SerializationTest < Minitest::Test
  parallelize_me!

  def setup
    Knuckles.cache = Knuckles::NullStore.new
  end

  def teardown
    Knuckles.reset!
  end

  def test_serialization_pipeline
    builder = Knuckles::Builder.new
    output = builder.call(posts, serializer: PostSerializer)

    assert_equal(JSON.dump({
      posts: [
        { id: 1, title: "Sonic", comment_ids: [1, 2] },
        { id: 2, title: "Tails", comment_ids: [] }
      ],
      comments: [
        { id: 1, body: "Sunny Meadow", author_id: 1 },
        { id: 2, body: "Mecha Zone", author_id: 1 }
      ],
      authors: [
        { id: 1, name: "Yukihiro" }
      ]
    }), output)
  end

  private

  def author
    @author ||= Author.new(1, "Yukihiro")
  end

  def comments
    @comments ||= [
      Comment.new(1, "Sunny Meadow", author),
      Comment.new(2, "Mecha Zone", author)
    ]
  end

  def posts
    @posts ||= [
      Post.new(1, "Sonic", author, comments),
      Post.new(2, "Tails", author, [])
    ]
  end
end
