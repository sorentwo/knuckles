RSpec.describe Knuckles::Hydrator do
  describe ".call" do
    it "is a noop without a hydrate lambda" do
      objects = [Tag.new(1, "alpha")]

      expect(Knuckles::Hydrator.call(objects, {})).to eq(objects)
    end

    it "refines the object collection using hydrate" do
      objects = [Tag.new(1, "alpha"), Tag.new(2, "gamma")]
      prepared = prepare(objects)

      hydrate = lambda do |hashes|
        hashes.each { |hash| hash[:object] = :updated }
      end

      hydrated = Knuckles::Hydrator.call(prepared, hydrate: hydrate)

      expect(hydrated.map { |hash| hash[:object] }).to eq([:updated, :updated])
    end
  end
end
