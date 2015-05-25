AuthorSerializer = Class.new(Knuckles::Serializer) do
  root :authors

  attributes :id, :name
end

CommentSerializer = Class.new(Knuckles::Serializer) do
  root :comments

  attributes :id, :body

  def self.includes
    { author: AuthorSerializer }
  end
end

PostSerializer = Class.new(Knuckles::Serializer) do
  root :posts

  attributes :id, :title

  def self.includes
    { comments: CommentSerializer }
  end
end
