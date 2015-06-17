require "test_helper"

class BuilderTest < Minitest::Test
  parallelize_me!

  def teardown
    Knuckles.reset!
  end

  # def test_instrumenting_filters
  #   builder = Knuckles::Builder.new([Filter])
  #   notifier = Minitest::Mock.new

  #   notifier.expect(:instrument, [],
  #     ['knuckles.filter', { filter: "downcase" }
  #   ])

  #   Knuckles.notifications = notifier

  #   builder.call([Object.new], serializer: Knuckles::Serializer)

  #   notifier.verify
  # end
end
