class RedList
  attr_reader :key

  def self.redis
    @redis ||= Red.new
  end

  def self.get(key)
    redis.execute_with_uncertainty([]) do
      redis.lrange(key, 0, -1).map(&:to_i)
    end
  end

  def self.get_strings(key)
    redis.execute_with_uncertainty([]) do
      redis.lrange(key, 0, -1)
    end
  end

  def self.add(key, value)
    redis.execute_with_uncertainty(false) do
      redis.lpush(key, value)
    end
  end

  def self.remove(key, value, occurrences = 0)
    redis.execute_with_uncertainty(false) do
      redis.lrem(key, occurrences, value)
    end
  end

  def self.count(key, value)
    get(key).count(value)
  end

  def self.total_size(key)
    get(key).count
  end

  def self.trim_to(key, amount)
    redis.execute_with_uncertainty(false) do
      redis.ltrim(key, 0, (amount - 1))
    end
  end

  def self.pop(key)
    redis.execute_with_uncertainty(false) do
      redis.rpop(key)
    end
  end

  def initialize(key)
    @key = key
  end

  def add(value)
    self.class.add(@key, value)
  end

  def remove(value)
    self.class.remove(@key, value)
  end

  def value
    self.class.get(@key)
  end
end
