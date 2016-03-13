RSpec.describe Knuckles::Writer do
  describe ".call" do
    it "writes all un-cached values" do
      objects = [
        {key: "tag/1/12345", cached?: true,  result: {tags: [{id: 1, name: "alpha"}]}},
        {key: "tag/2/23456", cached?: false, result: {tags: [{id: 2, name: "gamma"}]}}
      ]

      Knuckles::Writer.call(objects, {})

      expect(Knuckles.cache.read("tag/1/12345")).to be_nil
      expect(Knuckles.cache.read("tag/2/23456")).not_to be_nil
    end
  end
end
