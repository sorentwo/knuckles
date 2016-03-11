PostView = Module.new do
  extend Knuckles::View

  def self.root
    :posts
  end

  def self.data(post, _)
    {id: post.id, title: post.title, tag_ids: post.tags.map(&:id)}
  end

  def self.relations(post, _)
    {tags: has_many(post.tags, TagView)}
  end
end

TagView = Module.new do
  extend Knuckles::View

  def self.root
    :tags
  end

  def self.data(tag, _)
    {id: tag.id, name: tag.name}
  end
end

