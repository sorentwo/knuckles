AuthorSerializer = Class.new(Knuckles::Serializer) do
  root :authors

  attributes :id, :name
end

CommentSerializer = Class.new(Knuckles::Serializer) do
  root :comments

  attributes :id, :body

  has_one :author, serializer: AuthorSerializer
end

PostSerializer = Class.new(Knuckles::Serializer) do
  root :posts

  attributes :id, :title

  has_many :comments, serializer: CommentSerializer
end
