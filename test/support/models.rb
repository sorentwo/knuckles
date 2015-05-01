Author = Struct.new(:id, :name)

Comment = Struct.new(:id, :body)

Post = Struct.new(:id, :title) do
  attr_accessor :author, :comments
end

