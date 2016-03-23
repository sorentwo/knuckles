RSpec.describe Knuckles::Dumper do
  describe ".call" do
    it "dumps a tree of objects" do
      objects = {
        author: {id: 1, name: "Ernest"},
        posts: [
          {id: 1, title: "great"},
          {id: 2, title: "stuff"},
          {id: 2, title: "stuff"}
        ],
        tags: [
          {id: 1, name: "alpha"},
          {id: 2, name: "gamma"},
          {id: 1, name: "alpha"},
          {"id" => 2, "name" => "gamma"}
        ]
      }

      dumped = Knuckles::Dumper.call(objects, {})

      expect(dumped).to eq(
        JSON.dump(
          author: {id: 1, name: "Ernest"},
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
