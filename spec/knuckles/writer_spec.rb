RSpec.describe Knuckles::Writer do
  class FakeCache
    def write_multi(*)
      true
    end
  end

  after do
    Knuckles.reset!
  end

  describe ".call" do
    it "writes all un-cached values" do
      objects = [
        {key: "t/1/1", cached?: true,  result: {tags: [{id: 1, name: "a"}]}},
        {key: "t/2/2", cached?: false, result: {tags: [{id: 2, name: "b"}]}}
      ]

      Knuckles::Writer.call(objects, {})

      expect(Knuckles.cache.read("t/1/1")).to be_nil
      expect(Knuckles.cache.read("t/2/2")).not_to be_nil
    end

    it "leverages write multi for caches that support it" do
      objects = [
        {key: "t/1/1", cached?: false, result: {tags: []}},
        {key: "t/2/1", cached?: true, result: {tags: []}}
      ]

      Knuckles.cache = FakeCache.new

      expect(Knuckles.cache).to receive(:write_multi) { true }

      Knuckles::Writer.call(objects, {})
    end
  end
end
