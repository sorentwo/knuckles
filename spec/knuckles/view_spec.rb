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

  describe ".cache_key" do
    it "provides a default cache key strategy" do
      klass = Struct.new(:id, :updated_at)

      cache_key = TagView.cache_key(klass.new(123, Time.now))

      expect(cache_key).to match(%r{tags/123/\d+})
    end
  end

  describe ".has_one" do
    it "serializes an object using the given view" do
      object = Tag.new(1, "Alpha")

      expect(view.has_one(object, TagView)).to eq(
        id: object.id,
        name: object.name
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
end
