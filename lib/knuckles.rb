require "json"

module Knuckles
  extend self

  def render(objects, view, options = {})
    objects.each_with_object(backed_hash) do |object, memo|
      memo[view.root] << view.data(object, options)
    end
  end

  private

  def backed_hash
    Hash.new { |hash, key| hash[key] = [] }
  end
end
