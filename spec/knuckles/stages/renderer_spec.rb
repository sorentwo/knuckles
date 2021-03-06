RSpec.describe Knuckles::Stages::Renderer do
  describe ".call" do
    it "serializes a collection of objects" do
      tag_a  = Tag.new(1, "alpha")
      tag_b  = Tag.new(2, "gamma")
      post_a = Post.new(1, "hello", [tag_a, tag_b])
      post_b = Post.new(2, "there", [tag_a])

      objects = prepare([post_a, post_b])
      results = Knuckles::Stages::Renderer.call(objects, view: PostView)

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

    it "serializes using a class based renderer" do
      tag = Tag.new(1, "alpha")

      ar_view = Class.new do
        def initialize(object, _options)
          @object = object
        end

        def as_json
          {tags: [{id: @object.id, name: @object.name}]}
        end
      end

      results = Knuckles::Stages::Renderer.call(prepare([tag]), view: ar_view)

      expect(results[0][:result]).to eq(
        tags: [{id: 1, name: "alpha"}]
      )
    end
  end
end
