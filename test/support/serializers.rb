AuthorSerializer = Class.new(Knuckles::Serializer) do
  def self.attributes
    %i[id name]
  end
end

CommentSerializer = Class.new(Knuckles::Serializer) do
  def self.includes
    { author: AuthorSerializer }
  end

  def self.attributes
    %i[id body]
  end
end

PostSerializer = Class.new(Knuckles::Serializer) do
  def self.includes
    { comments: CommentSerializer }
  end

  def self.attributes
    %i[id title]
  end
end
