require "time"

RSpec.describe Knuckles::View do
  let(:view) { Knuckles::View }

  describe "callback methods" do
    it "defines defaults for all callback methods" do
      obj = Object.new

      expect(view.root).to be_nil
      expect(view.data(obj)).to eq({})
      expect(view.relations(obj)).to eq({})
    end
  end

  describe ".has_one" do
    it "serializes an object using the given view" do
      object = Tag.new(1, "Alpha")

      expect(view.has_one(object, TagView)).to eq(
        [{id: object.id, name: object.name}]
      )
    end
  end

  describe ".has_many" do
    it "serializes all objects using the given view" do
      object_a = Tag.new(1, "Alpha")
      object_b = Tag.new(2, "Beta")

      objects = [object_a, object_b]

      expect(view.has_many(objects, TagView)).to eq(
        [{id: 1, name: "Alpha"}, {id: 2, name: "Beta"}]
      )
    end
  end

  describe ".render" do
    it "performs combined rendering of relations and data" do
      tag = Tag.new(1, "Alpha")

      expect(TagView.render(tag)).to eq(
        tags: [{id: 1, name: "Alpha"}]
      )
    end
  end
end
