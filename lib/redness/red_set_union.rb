class RedSetUnion
  attr_accessor :keys, :redis

  def initialize(*keys)
    self.keys = keys
    self.redis = Red.new

    @temporary_key = "tmp:red_set_union"
  end

  def get(options = {})
    lower_bound = options[:lower] || 0
    upper_bound = options[:upper] || -1

    redis.execute_with_uncertainty([]) do
      results = redis.multi_with_caution do
        redis.zunionstore(@temporary_key, keys)
        redis.zrevrange(@temporary_key, lower_bound, upper_bound)
        redis.del(@temporary_key)
      end

      if results.present?
        results[1].flatten.compact.uniq.map(&:to_i)
      else
        []
      end
    end
  end
end
