class RedExpire < Red
  def self.redis
    @redis ||= Red.new
  end

  def self.set(key, expires_in)
    redis.execute_with_uncertainty(nil) do
      redis.expire(key, expires_in.seconds.to_i)
    end
  end
end
