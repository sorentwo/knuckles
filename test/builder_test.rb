require "test_helper"

class BuilderTest < Minitest::Test
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
    builder = Knuckles::Builder.new([Filter])

    assert_equal ['tails'], builder.call(['TAILS'])
  end

  def test_instrumenting_filters
    builder = Knuckles::Builder.new([Filter])
    notifier = Minitest::Mock.new

    notifier.expect(:instrument, [],
      ['knuckles.filter', { filter: 'downcase', context: {}}
    ])

    Knuckles.notifications = notifier

    builder.call([Object.new])

    notifier.verify
  end
end
