RSpec.describe Knuckles::Dumper do
  describe ".call" do
    it "dumps a tree of objects" do
      objects = {
        posts: Set.new([
          {id: 1, title: "great"},
          {id: 2, title: "stuff"}
        ]),
        tags: Set.new([
          {id: 1, name: "alpha"},
          {id: 2, name: "gamma"}
        ])
      }

      dumped = Knuckles::Dumper.call(objects, {})

      expect(dumped).to eq(
        JSON.dump(
          posts: [
            {id: 1, title: "great"},
            {id: 2, title: "stuff"}
          ],
          tags: [
            {id: 1, name: "alpha"},
            {id: 2, name: "gamma"}
          ]
        )
      )
    end
  end
end
