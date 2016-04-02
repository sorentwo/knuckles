RSpec.describe Knuckles::Stages::Fetcher do
  describe ".call" do
    it "fetches all cached data for top level objects" do
      objects = [Tag.new(1, "alpha"), Tag.new(2, "gamma")]

      Knuckles.cache.write(Knuckles.keygen.expand_key(objects.first), "result")

      objects = prepare(objects)
      results = Knuckles::Stages::Fetcher.call(objects, {})

      expect(pluck(results, :result)).to eq(["result", nil])
      expect(pluck(results, :cached?)).to eq([true, false])
    end

    it "allows passing a custom keygen" do
      keygen = Module.new do
        def self.expand_key(object)
          object.name
        end
      end

      objects = prepare([Tag.new(1, "alpha")])
      results = Knuckles::Stages::Fetcher.call(objects, keygen: keygen)

      expect(pluck(results, :key)).to eq(["alpha"])
    end
  end

  def pluck(enum, key)
    enum.map { |hash| hash[key] }
  end
end
