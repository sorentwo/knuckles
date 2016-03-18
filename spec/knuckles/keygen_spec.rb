RSpec.describe Knuckles::Keygen do
  FakeKeyModel = Struct.new(:id, :updated_at)

  describe ".cache_key" do
    it "provides a simple default cache key" do
      cache_key = Knuckles::Keygen.expand_key(FakeKeyModel.new(123, Time.now))

      expect(cache_key).to match(%r{FakeKeyModel/123/\d+})
    end

    it "respects an object with a cache_key method" do
      model = double(:model, cache_key: "abcdefg")

      cache_key = Knuckles::Keygen.expand_key(model)

      expect(cache_key).to eq("abcdefg")
    end
  end
end
