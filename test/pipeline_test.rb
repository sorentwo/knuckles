require "test_helper"

class PipelineTest < Minitest::Test
  parallelize_me!

  def teardown
    Knuckles.reset!
  end

  module Filter
    extend self

    def name; 'downcase'; end
    def call(strs, _); strs.map(&:downcase); end
  end

  def test_reducing_with_filters
    pipeline = Knuckles::Pipeline.new([Filter])

    assert_equal ['tails'], pipeline.call(['TAILS'])
  end

  def test_instrumenting_filters
    pipeline = Knuckles::Pipeline.new([Filter])
    notifier = Minitest::Mock.new

    notifier.expect(:instrument, [],
      ['knuckles.filter', { filter: 'downcase', context: {}}
    ])

    Knuckles.notifications = notifier

    pipeline.call([Object.new])

    notifier.verify
  end
end
