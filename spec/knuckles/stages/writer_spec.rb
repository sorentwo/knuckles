RSpec.describe Knuckles::Stages::Writer do
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
      prepared = [
        {key: "t/1/1", cached?: true,  result: {tags: [{id: 1, name: "a"}]}},
        {key: "t/2/2", cached?: false, result: {tags: [{id: 2, name: "b"}]}}
      ]

      result = Knuckles::Stages::Writer.call(prepared, {})

      expect(result).to eq(prepared)
      expect(Knuckles.cache.read("t/1/1")).to be_nil
      expect(Knuckles.cache.read("t/2/2")).not_to be_nil
    end

    it "leverages write multi for caches that support it" do
      prepared = [
        {key: "t/1/1", cached?: false, result: {tags: []}},
        {key: "t/2/1", cached?: true, result: {tags: []}}
      ]

      Knuckles.cache = FakeCache.new

      expect(Knuckles.cache).to receive(:write_multi) { true }

      result = Knuckles::Stages::Writer.call(prepared, {})

      expect(result).to eq(prepared)
    end
  end
end
