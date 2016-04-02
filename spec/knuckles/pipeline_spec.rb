RSpec.describe Knuckles::Pipeline do
  describe "#stages" do
    it "sets the default stages" do
      pipeline = Knuckles::Pipeline.new

      expect(pipeline.stages).not_to be_empty
    end

    it "allows stages to be customeized on initialization" do
      pipeline = Knuckles::Pipeline.new(stages: [])

      expect(pipeline.stages).to be_empty
    end
  end

  describe "#delete" do
    it "removes an existing stage" do
      pipeline = Knuckles::Pipeline.new

      pipeline.delete(Knuckles::Stages::Writer)

      expect(pipeline.stages).not_to include(Knuckles::Stages::Writer)
    end
  end

  describe "#insert_after" do
    it "adds a stage after an existing stage" do
      custom = Module.new
      pipeline = Knuckles::Pipeline.new

      pipeline.insert_after(Knuckles::Stages::Fetcher, custom)

      expect(pipeline.stages).to include(custom)
      expect(pipeline.stages.take(2)).to eq([
        Knuckles::Stages::Fetcher,
        custom
      ])
    end
  end

  describe "#insert_before" do
    it "adds a stage after an existing stage" do
      custom = Module.new
      pipeline = Knuckles::Pipeline.new

      pipeline.insert_before(Knuckles::Stages::Fetcher, custom)

      expect(pipeline.stages).to include(custom)
      expect(pipeline.stages.take(2)).to eq([
        custom,
        Knuckles::Stages::Fetcher
      ])
    end
  end

  describe "#call" do
    it "aggregates the result of all stages" do
      filter_a = Module.new do
        def self.name
          "strip"
        end

        def self.call(objects, _)
          objects.each { |hash| hash[:object].strip! }
        end
      end

      filter_b = Module.new do
        def self.name
          "downcase"
        end

        def self.call(objects, _)
          objects.each { |hash| hash[:object].downcase! }
        end
      end

      pipeline = Knuckles::Pipeline.new(stages: [filter_a, filter_b])

      expect(pipeline.call([" KNUCKLES "], {}))
        .to eq([{object: "knuckles", cached?: false, key: nil, result: nil}])
    end
  end

  describe "#prepare" do
    it "wraps all objects in entities" do
      object = Object.new
      prepared, = Knuckles::Pipeline.new.prepare([object])

      expect(prepared[:object]).to be(object)
      expect(prepared[:key]).to be_nil
      expect(prepared[:result]).to be_nil
      expect(prepared[:cached?]).to be_falsey
    end
  end
end
