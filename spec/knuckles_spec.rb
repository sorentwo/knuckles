require "knuckles"
require "knuckles/view"

Post = Struct.new(:id, :title, :tags)
Tag  = Struct.new(:id, :name)

PostView = Module.new do
  extend Knuckles::View

  def self.root
    "posts"
  end

  def self.data(post, _)
    {id: post.id, title: post.title}
  end

  def self.relations(post, _)
    {tags: has_many(post.tags, TagView)}
  end
end

TagView = Module.new do
  extend Knuckles::View

  def self.root
    "tags"
  end

  def self.data(tag, _)
    {id: tag.id, name: tag.name}
  end
end

RSpec.describe Knuckles do
  describe "#render" do
    it "serializes a collection of objects" do
      posts = [Post.new(1, "hello", []), Post.new(2, "there", [])]

      rendered = Knuckles.render(posts, PostView)

      expect(rendered).to eq(
        posts: [
          {id: 1, title: "hello", tag_ids: [1, 2]},
          {id: 2, title: "there", tag_ids: [1]}
        ],
        tags: [
          {id: 1, name: "alpha"},
          {id: 2, name: "gamma"}
        ]
      )
    end
  end
end
