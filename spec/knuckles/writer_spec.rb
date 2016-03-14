RSpec.describe Knuckles::Writer do
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
  end
end
