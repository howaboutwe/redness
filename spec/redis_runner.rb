class RedisRunner
  def self.start
    pid = fork do
      $0 = "redis:start - #{host} : #{port}"
      `cd tmp && echo port #{port} | redis-server -`
      at_exit { exit! }
    end

    "#{host}:#{port}"
  end

  def self.stop
    `redis-cli -h #{host} -p #{port} 'SHUTDOWN'`

    "#{host}:#{port}"
  end

  private

  def self.host
    "localhost"
  end

  def self.port
    "6380"
  end
end
