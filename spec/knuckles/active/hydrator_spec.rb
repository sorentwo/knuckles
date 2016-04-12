RSpec.describe Knuckles::Active::Hydrator do
  class FakeRelation
    attr_reader :objects

    def initialize(objects)
      @objects = objects
    end

    def offset(_bool)
      self
    end

    def limit(_bool)
      self
    end

    def where(id:)
      objects.select { |object| id.include?(object.id) }
    end
  end

  describe ".call" do
    it "is a no-op if all objects are cached" do
      prepared = prepare([Tag.new(1, "alpha")])

      prepared.each { |prep| prep[:cached?] = true }

      expect(Knuckles::Active::Hydrator.call(prepared, {})).to eq(prepared)
    end

    it "replaces all objects using the results of a query" do
      prepared = prepare([Tag.new(1, nil), Tag.new(2, nil)])
      relation = FakeRelation.new([Tag.new(1, "alpha"), Tag.new(2, "beta")])

      results = Knuckles::Active::Hydrator.call(prepared, relation: relation)

      expect(results.map { |hash| hash[:object] }).to eq([
        Tag.new(1, "alpha"),
        Tag.new(2, "beta")
      ])
    end
  end
end
