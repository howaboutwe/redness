class RedisRunner
  def self.start
    fork do
      `mkdir -p tmp && cd tmp && echo port #{port} | redis-server -`
       at_exit { exit! }
    end
  end

  def self.stop
    `redis-cli -h #{host} -p #{port} 'SHUTDOWN'`

    "#{host}:#{port}"
  end

  def self.up?
    system("redis-cli -h #{host} -p #{port} 'INFO' 2&> /dev/null")
    $? == 0
  end

  private

  def self.host
    "localhost"
  end

  def self.port
    "6379"
  end
end
