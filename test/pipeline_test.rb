require "test_helper"

class PipelineTest < Minitest::Test
  def test_reducing_with_filters
    filter_a = -> (strs, _) { strs.map(&:downcase) }
    filter_b = -> (strs, _) { strs.map(&:strip) }

    pipeline = Knuckles::Pipeline.new([
      filter_a,
      filter_b
    ])

    assert_equal ['tails'], pipeline.call([' TAILS '])
  end
end
