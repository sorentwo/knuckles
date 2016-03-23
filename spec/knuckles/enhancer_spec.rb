RSpec.describe Knuckles::Enhancer do
  describe ".call" do
    it "is a noop without an enhancer lambda" do
      prepared = [Tag.new(1, "alpha")]

      expect(Knuckles::Enhancer.call(prepared, {})).to eq(prepared)
    end

    it "modifies the rendered values with a lambda" do
      prepared = [
        {result: {"posts" => [], "tags" => []}},
        {result: {"posts" => [], "tags" => []}}
      ]

      enhanced = Knuckles::Enhancer.call(
        prepared,
        tagless: true,
        enhancer: lambda do |result, options|
          if options[:tagless]
            result.delete_if { |key, _| key == "tags" }
          end

          result
        end
      )

      expect(enhanced).to eq([
        {result: {"posts" => []}},
        {result: {"posts" => []}}
      ])
    end
  end
end
