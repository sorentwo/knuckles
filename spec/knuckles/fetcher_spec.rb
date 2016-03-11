RSpec.describe Knuckles::Fetcher do
  describe ".call" do
    it "fetches all cached data for top level objects" do
      objects = [Tag.new(1, "alpha"), Tag.new(2, "gamma")]

      Knuckles.cache.write(TagView.cache_key(objects.first), "result")

      objects = Knuckles.prepare(objects)
      results = Knuckles::Fetcher.call(objects, view: TagView)
      results = results.map { |hash| hash[:result] }

      expect(results).to eq(["result", nil])
    end
  end
end
