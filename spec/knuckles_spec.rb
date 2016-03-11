require "knuckles"
require "knuckles/view"

Post = Struct.new(:id, :title, :tags)
Tag  = Struct.new(:id, :name)

PostView = Module.new do
  extend Knuckles::View

  def self.root
    :posts
  end

  def self.data(post, _)
    {id: post.id, title: post.title, tag_ids: post.tags.map(&:id)}
  end

  def self.relations(post, _)
    {tags: has_many(post.tags, TagView)}
  end
end

TagView = Module.new do
  extend Knuckles::View

  def self.root
    :tags
  end

  def self.data(tag, _)
    {id: tag.id, name: tag.name}
  end
end

RSpec.describe Knuckles do
  let(:tag_a)  { Tag.new(1, "alpha") }
  let(:tag_b)  { Tag.new(2, "gamma") }
  let(:post_a) { Post.new(1, "hello", [tag_a, tag_b]) }
  let(:post_b) { Post.new(2, "there", [tag_a]) }

  describe "#render" do
    it "serializes a collection of objects" do
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
