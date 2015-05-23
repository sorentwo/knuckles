require "test_helper"

class BuildFilterTest < Minitest::Test
  Filter = Knuckles::Pipeline::BuildFilter
  Serializer = Struct.new(:root, :serialized)

  def test_building_nodes_without_children
    inst_a = Serializer.new("posts", JSON.dump(id: 1, title: 'Sonic'))
    inst_b = Serializer.new("posts", JSON.dump(id: 2, title: 'Tails'))

    output = Filter.call([inst_a, inst_b])

    assert_equal(JSON.dump({
      posts: [
        { id: 1, title: "Sonic" },
        { id: 2, title: "Tails" }
      ]
    }), output)
  end

  def test_building_nodes_with_different_roots
    inst_a = Serializer.new("posts",    JSON.dump(id: 1, title: "Sonic"))
    inst_b = Serializer.new("posts",    JSON.dump(id: 2, title: "Tails"))
    inst_c = Serializer.new("comments", JSON.dump(id: 1, body: "Sunny Meadow"))
    inst_d = Serializer.new("authors",  JSON.dump(id: 1, name: "Yoshi"))

    output = Filter.call([inst_a, inst_b, inst_c, inst_d])

    assert_equal(JSON.dump({
      posts: [
        { id: 1, title: "Sonic" },
        { id: 2, title: "Tails" }
      ],
      comments: [
        { id: 1, body: "Sunny Meadow" }
      ],
      authors: [
        { id: 1, name: "Yoshi" }
      ]
    }), output)
  end
end
