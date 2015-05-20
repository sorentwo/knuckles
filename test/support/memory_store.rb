class MemoryStore
  def initialize
    @store = {}
  end

  def write(key, value)
    @store[key] = value
  end

  def read_multi(*keys)
    keys.each_with_object({}) do |key, memo|
      memo[key] = @store[key.join('/')]
    end
  end

  def clear
    @store = {}
  end
end
