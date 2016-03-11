RSpec.describe Knuckles::Pipeline do
  describe "#stages" do
    it "sets the default stages" do
      pipeline = Knuckles::Pipeline.new

      expect(pipeline.stages).not_to be_empty
    end

    it "allows stages to be customeized" do
      pipeline = Knuckles::Pipeline.new(stages: [])

      expect(pipeline.stages).to be_empty
    end
  end

  describe "#call" do
    it "aggregates the result of all stages" do
      filter_a = Module.new do
        def self.name
          'strip'
        end

        def self.call(objects, _)
          objects.map { |hash| hash[:object].strip!; hash }
        end
      end

      filter_b = Module.new do
        def self.name
          'downcase'
        end

        def self.call(objects, _)
          objects.map { |hash| hash[:object].downcase!; hash }
        end
      end

      pipeline = Knuckles::Pipeline.new(stages: [filter_a, filter_b])

      expect(pipeline.call([" KNUCKLES "], {}))
        .to eq([{object: "knuckles", key: nil, result: nil}])
    end
  end
end
