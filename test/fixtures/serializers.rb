AuthorSerializer = Class.new(Knuckles::Serializer) do
  root :authors

  attributes :id, :name

  def cache_key
    "author/#{id}"
  end
end

CommentSerializer = Class.new(Knuckles::Serializer) do
  root :comments

  attributes :id, :body

  has_one :author, serializer: AuthorSerializer

  def cache_key
    "comments/#{id}"
  end
end

PostSerializer = Class.new(Knuckles::Serializer) do
  root :posts

  attributes :id, :title

  has_many :comments, serializer: CommentSerializer

  def cache_key
    "posts/#{id}"
  end
end
