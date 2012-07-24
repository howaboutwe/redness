require 'timeout'

class Red
  class RedisUnavailable < StandardError; end

  def self.redis
    $redis
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
  rescue RedisUnavailable, Redis::CannotConnectError, Errno::ECONNREFUSED, Timeout, Timeout::Error, Errno::EAGAIN
    fail_return
  end

  def multi_with_caution(fail_return = [])
    redis.multi
    yield
    redis.exec
  rescue
    redis.discard
    fail_return
  end

  def method_missing(method, *args)
    raise RedisUnavailable unless redis
    redis.send(method, *args)
  end
end
