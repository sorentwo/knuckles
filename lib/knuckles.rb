require "json"
require "set"
require "knuckles/view"

module Knuckles
  extend self

  def render(objects, view, options = {})
    objects.each_with_object(set_backed_hash) do |object, memo|
      memo[view.root] << view.data(object, options)

      view.relations(object, options).each do |root, data|
        memo[root] += data
      end
    end
  end

  def render_to_string(object, view, options = {})
    JSON.dump(set_backed_to_array(render(object, view, options)))
  end

  private

  def set_backed_hash
    Hash.new { |hash, key| hash[key] = Set.new }
  end

  def set_backed_to_array(hash)
    hash.each_with_object({}) do |(root, set), memo|
      memo[root] = set.to_a
    end
  end
end
