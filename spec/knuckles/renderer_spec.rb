RSpec.describe Knuckles::Renderer do
  describe ".call" do
    it "serializes a collection of objects" do
      tag_a  = Tag.new(1, "alpha")
      tag_b  = Tag.new(2, "gamma")
      post_a = Post.new(1, "hello", [tag_a, tag_b])
      post_b = Post.new(2, "there", [tag_a])

      objects = prepare([post_a, post_b])
      results = Knuckles::Renderer.call(objects, view: PostView)

      expect(results[0][:result]).to eq(
        posts: [
          {id: 1, title: "hello", tag_ids: [1, 2]}
        ],
        tags: [
          {id: 1, name: "alpha"},
          {id: 2, name: "gamma"}
        ]
      )

      expect(results[1][:result]).to eq(
        posts: [
          {id: 2, title: "there", tag_ids: [1]}
        ],
        tags: [
          {id: 1, name: "alpha"}
        ]
      )
    end
  end
end
