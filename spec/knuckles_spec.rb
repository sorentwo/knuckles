require "knuckles"

RSpec.describe Knuckles do
  after do
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
end
