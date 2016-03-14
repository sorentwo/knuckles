require_relative "./bench_helper"

Post = Struct.new(:id, :title, :updated_at)

module PostView
  extend Knuckles::View

  def self.root
    :posts
  end

  def self.data(object, _)
    { id: object.id,
      title: object.title,
      updated_at: object.updated_at }
  end
end

models = 100.times.map { |i| Post.new(i, "title", Time.new) }

Benchmark.ips do |x|
  x.report("serialize.main") do
    Knuckles.render(models, view: PostView)
  end
end
