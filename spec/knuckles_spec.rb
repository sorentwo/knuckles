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
end
