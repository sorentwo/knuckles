Post = Struct.new(:id, :title, :tags) do
  def updated_at
    Time.now
  end
end

Tag = Struct.new(:id, :name) do
  def updated_at
    Time.now
  end
end
