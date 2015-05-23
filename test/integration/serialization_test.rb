require "test_helper"

class SerializationTest < Minitest::Test
  # def test_serializing_without_caching
  #   pipeline = Knuckles::Pipeline.new [
  #     Knuckles::Pipeline::NodeFilter,
  #     Knuckles::Pipeline::ChildrenFilter,
  #     Knuckles::Pipeline::SerializeFilter,
  #     Knuckles::Pipeline::BuildFilter
  #   ]

  #   output = pipeline.call(posts, serializer: PostSerializer)

  #   assert_equal(JSON.dump({
  #     posts: [
  #       { id: 1, title: "Sonic" },
  #       { id: 2, title: "Tails" }
  #     ],
  #     comments: [
  #       { id: 1, body: "Sunny Meadow" }
  #     ],
  #     authors: [
  #       { id: 1, name: "Yukihiro" }
  #     ]
  #   }), output)
  # end

  private

  def author
    @author ||= Author.new(1, "Yukihiro")
  end

  def comments
    @comments ||= [
      Comment.new(1, "Sunny Medow", author),
      Comment.new(2, "Mecha Zone", author)
    ]
  end

  def posts
    @posts ||= [
      Post.new(1, "Sonic", author, comments: comments),
      Post.new(2, "Tails", author, [])
    ]
  end
end
