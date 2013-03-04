require 'timeout'

class Red
  class RedisUnavailable < StandardError; end

  class << self
    attr_accessor :redis
  end

  def self.client_version
    @version ||= Redis::VERSION.scan(/\d+/).map { |s| s.to_i }
  end

  def self.delete(key)
    redis.del(key)
  end

  def redis
    Red.redis
  end

  def execute_with_uncertainty(fail_return = [])
    yield
  rescue RedisUnavailable, Redis::CannotConnectError, Redis::TimeoutError
    fail_return
  end

  def multi_with_caution(fail_return = [], &block)
    begin
      redis.multi(&block) || fail_return
    rescue Redis::TimeoutError
      # The redis client pipelines the commands internally. It's possible the
      # MULTI succeeds, but there's a timeout before reaching the EXEC. Try to
      # issue an extra discard to ensure the transaction is closed.
      redis.discard  # may raise Redis::CommandError if MULTI never succeeded
      raise
    end
  rescue
    fail_return
  end

  def method_missing(method, *args)
    raise RedisUnavailable unless redis
    redis.send(method, *args)
  end
end
