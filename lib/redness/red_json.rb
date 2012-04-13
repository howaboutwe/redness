class RedJSON < Red
  def self.redis
    @redis ||= Red.new
  end

  def self.get(key)
    redis.execute_with_uncertainty(nil) do
      value = redis.get(key)

      if value
        JSON.parse(value)
      end
    end
  end

  def self.set(key, value)
    redis.execute_with_uncertainty(nil) do
      redis.set(key, value.to_json)
    end
  end
end
