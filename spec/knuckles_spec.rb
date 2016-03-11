require "knuckles"

RSpec.describe Knuckles do
  before do
    Knuckles.serializer = JSON
  end

  describe "#serializer" do
    it "can be overridden" do
      custom = Object.new

      Knuckles.serializer = custom

      expect(Knuckles.serializer).to eq(custom)
    end
  end

  describe "#render" do
    it "serializes a collection of objects" do
      tag_a  = Tag.new(1, "alpha")
      tag_b  = Tag.new(2, "gamma")
      post_a = Post.new(1, "hello", [tag_a, tag_b])
      post_b = Post.new(2, "there", [tag_a])

      rendered = Knuckles.render([post_a, post_b], PostView)

      expect(rendered).to eq(
        posts: Set.new([
          {id: 1, title: "hello", tag_ids: [1, 2]},
          {id: 2, title: "there", tag_ids: [1]}
        ]),
        tags: Set.new([
          {id: 1, name: "alpha"},
          {id: 2, name: "gamma"}
        ])
      )
    end
  end

  describe "#render_to_string" do
    it "dumps the serialized collection to a string" do
      tag_a  = Tag.new(1, "alpha")
      tag_b  = Tag.new(2, "gamma")
      post_a = Post.new(1, "hello", [tag_a, tag_b])
      post_b = Post.new(2, "there", [tag_a])

      rendered = Knuckles.render_to_string([post_a, post_b], PostView)

      expect(rendered).to eq(JSON.dump(
        posts: [
          {id: 1, title: "hello", tag_ids: [1, 2]},
          {id: 2, title: "there", tag_ids: [1]}
        ],
        tags: [
          {id: 1, name: "alpha"},
          {id: 2, name: "gamma"}
        ]
      ))
    end
  end
end
