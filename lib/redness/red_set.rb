class RedSet
  attr_reader :key

  def self.redis
    @redis ||= Red.new
  end

  def self.add(key, member, options = {})
    redis.execute_with_uncertainty do
      redis.watch(key)

      if redis.zrank(key, member).nil?
        if options[:score] and options[:score].respond_to?(:call)
          score = options[:score].call.to_i
        elsif options[:score] && options[:score].respond_to?(:to_i)
          score = options[:score].to_i
        else
          score = redis.zcard(key).to_i
        end

        redis.multi_with_caution(false) do
          redis.zadd(key, score.to_s, member)
        end
      end
    end
  ensure
    redis.execute_with_uncertainty(0) do
      redis.unwatch
    end
  end

  def self.cap(key, size)
    redis.execute_with_uncertainty(0) do
      redis.zremrangebyrank(key, 0, -(size + 1))
    end
  end

  def self.remove(key, member)
    redis.execute_with_uncertainty do
      redis.zrem(key, member)
    end
  end

  def self.get(key, options = {})
    lower_bound = options[:lower] || 0
    upper_bound = options[:upper] || -1
    with_scores = options[:with_scores] || false
    scoring     = options[:scoring] || lambda {|x| x}

    redis.execute_with_uncertainty([]) do
      results = redis.zrevrange(key, lower_bound, upper_bound, :with_scores => with_scores)
      if with_scores
        [].tap do |memo|
          if Red.client_version.first < 3
            results.each_slice(2) do |slice|
              memo << [slice[0].to_i, scoring.call(slice[1].to_i)]
            end
          else
            results.each do |member, score|
              memo << [member.to_i, scoring.call(score)]
            end
          end
        end
      else
        results.map(&:to_i)
      end
    end
  end

  def self.get_strings(key, options = {})
    lower_bound = options[:lower] || 0
    upper_bound = options[:upper] || -1

    redis.execute_with_uncertainty do
      redis.zrevrange(key, lower_bound, upper_bound)
    end
  end

  def self.count(key)
    redis.execute_with_uncertainty(0) do
      redis.zcard(key)
    end
  end

  def self.score(key, member)
    redis.execute_with_uncertainty(nil) do
      redis.zscore(key, member)
    end
  end

  def initialize(key)
    @key = key
  end

  def add(value, options = {})
    self.class.add(@key, value, options)
  end

  def value
    self.class.get(@key)
  end

  def remove(value)
    self.class.remove(@key, value)
  end
end
