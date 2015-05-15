require "test_helper"

class PipelineTest < Minitest::Test
  def test_reducing_with_filters
    filter_a = -> (str, _) { str.map(&:downcase) }
    filter_b = -> (str, _) { str.map(&:strip) }

    pipeline = Knuckles::Pipeline.new([
      filter_a,
      filter_b
    ])

    assert_equal ['tails'], pipeline.call([' TAILS '])
  end
end
