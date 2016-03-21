RSpec.describe Knuckles::Combiner do
  describe ".call" do
    it "merges all results into a single object" do
      prepared = [
        {
          result: {
            author: {id: 1, name: "Michael"},
            posts: [{id: 1, title: "hello", tag_ids: [1, 2]}],
            tags: [{id: 1, name: "alpha"}, {id: 2, name: "gamma"}]
          }
        }, {
          result: {
            posts: [{id: 2, title: "there", tag_ids: [1]}],
            tags: [{id: 1, name: "alpha"}]
          }
        }
      ]

      combined = Knuckles::Combiner.call(prepared, {})

      expect(combined).to eq(
        author: Set.new([
          {id: 1, name: "Michael"}
        ]),
        posts: Set.new([
          {id: 1, title: "hello", tag_ids: [1, 2]},
          {id: 2, title: "there", tag_ids: [1]}
        ]),
        tags: Set.new([
          {id: 1, name: "alpha"},
          {id: 2, name: "gamma"}
        ])
      )
    end
  end
end
