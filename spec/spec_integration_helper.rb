$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'redis'
require 'active_support'
require 'active_support/core_ext'
require 'timecop'

require 'redis_runner'
require 'redness'

RSpec.configure do |config|
  config.before(:suite) do
    print "Starting Redis..."

    RedisRunner.start

    attempts = 10

    until RedisRunner.up? or attempts <= 0
      sleep 1
      attempts -= 1
    end

    if RedisRunner.up? 
      puts " OK"
    else
      puts " FAIL"
    end

    Red.redis = Redis.new(
      host: RedisRunner.host,
      port: RedisRunner.port,
      thread_safe: true
    )
  end

  config.after(:suite) do
    RedisRunner.stop
  end

  config.after(:each) do
    Timecop.return
    Red.redis.flushall
  end
end
