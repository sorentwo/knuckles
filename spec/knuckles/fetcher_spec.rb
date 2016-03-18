RSpec.describe Knuckles::Fetcher do
  describe ".call" do
    it "fetches all cached data for top level objects" do
      objects = [Tag.new(1, "alpha"), Tag.new(2, "gamma")]

      Knuckles.cache.write(TagView.cache_key(objects.first), "result")

      objects = prepare(objects)
      results = Knuckles::Fetcher.call(objects, view: TagView)

      expect(pluck(results, :result)).to eq(["result", nil])
      expect(pluck(results, :cached?)).to eq([true, false])
    end
  end

  def pluck(enum, key)
    enum.map { |hash| hash[key] }
  end
end
