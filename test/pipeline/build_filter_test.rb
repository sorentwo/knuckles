require "test_helper"

class BuildFilterTest < Minitest::Test
  Filter = Knuckles::Pipeline::BuildFilter
  Node   = Knuckles::Node

  def test_building_nodes_without_children
    node_a = Node.new(nil, root: "posts", serialized: JSON.dump(id: 1, title: 'Sonic'))
    node_b = Node.new(nil, root: "posts", serialized: JSON.dump(id: 2, title: 'Tails'))

    output = Filter.call([node_a, node_b], {})

    assert_equal(JSON.dump({
      posts: [
        { id: 1, title: 'Sonic' },
        { id: 2, title: 'Tails' }
      ]
    }), output)
  end

  def test_building_nodes_with_different_roots
    node_a = Node.new(nil, root: "posts",    serialized: JSON.dump(id: 1, title: 'Sonic'))
    node_b = Node.new(nil, root: "posts",    serialized: JSON.dump(id: 2, title: 'Tails'))
    node_c = Node.new(nil, root: "comments", serialized: JSON.dump(id: 1, body: 'Sunny Meadow'))
    node_d = Node.new(nil, root: "authors",  serialized: JSON.dump(id: 1, name: 'Yoshi'))

    output = Filter.call([node_a, node_b, node_c, node_d])

    assert_equal(JSON.dump({
      posts: [
        { id: 1, title: 'Sonic' },
        { id: 2, title: 'Tails' }
      ],
      comments: [
        { id: 1, body: 'Sunny Meadow' }
      ],
      authors: [
        { id: 1, name: 'Yoshi' }
      ]
    }), output)
  end
end
