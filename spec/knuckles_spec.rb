require "knuckles"

RSpec.describe Knuckles do
  before do
    Knuckles.reset!
  end

  describe "customization" do
    it "all dependencies can be overridden" do
      custom = Object.new

      Knuckles.cache = custom
      Knuckles.notifications = custom
      Knuckles.serializer = custom

      expect(Knuckles.cache).to eq(custom)
      expect(Knuckles.notifications).to eq(custom)
      expect(Knuckles.serializer).to eq(custom)
    end
  end

  describe "#prepare" do
    it "wraps all objects in entities" do
      object = Object.new
      prepared, = Knuckles.prepare([object])

      expect(prepared[:object]).to be(object)
      expect(prepared[:key]).to be_nil
      expect(prepared[:result]).to be_nil
      expect(prepared[:cached?]).to be_falsey
    end
  end
end
