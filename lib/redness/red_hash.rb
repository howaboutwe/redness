class RedHash
  attr_accessor :hash_key, :redis

  def initialize(hash_key = self.class.name, redis = Red.new)
    self.hash_key = hash_key
    self.redis = redis
  end

  def []=(key, value)
    redis.execute_with_uncertainty(nil) do
      redis.hset(hash_key, key, value)
      value
    end
  end

  def [](key)
    redis.execute_with_uncertainty(nil) do
      redis.hget(hash_key, key)
    end
  end

  def remove(key)
    redis.execute_with_uncertainty(false) do
      redis.hdel(hash_key, key)
    end
  end

  def all
    redis.execute_with_uncertainty({}) do
      hash = redis.hgetall(hash_key)

      HashWithIndifferentAccess.new(hash)
    end
  end

  def clear
    redis.execute_with_uncertainty(false) do
      redis.hkeys(hash_key).each do |key|
        redis.hdel(hash_key, key)
      end
    end
  end

  def get(key)
    self[key]
  end

  def set(options)
    redis.execute_with_uncertainty(false) do
      options.keys.each do |option|
        self[option] = options[option]
      end
    end
  end
end
