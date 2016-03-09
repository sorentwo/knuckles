FooModel = Struct.new(:id, :name)

FooView = Module.new do
  extend Knuckles::View

  def self.data(object, _ = {})
    { id: object.id, name: object.name }
  end
end

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
      object = FooModel.new(1, "Alpha")

      expect(view.has_one(object, FooView)).to eq(
        id: object.id,
        name: object.name
      )
    end
  end

  describe ".has_many" do
    it "serializes all objects using the given view" do
      object_a = FooModel.new(1, "Alpha")
      object_b = FooModel.new(2, "Beta")

      objects = [object_a, object_b]

      expect(view.has_many(objects, FooView)).to eq([
        { id: 1, name: "Alpha" },
        { id: 2, name: "Beta" }
      ])
    end
  end
end
