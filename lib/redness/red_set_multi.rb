class RedSetMulti
  attr_accessor :keys, :redis

  def initialize(*keys)
    self.keys = keys
    self.redis = Red.new
  end

  def get(options = {})
    lower_bound = options[:lower] || 0
    upper_bound = options[:upper] || -1

    redis.execute_with_uncertainty([]) do
      results = keys.map { |key| redis.zrevrange(key, lower_bound, upper_bound) }

      if results.present?
        results.map {|r| r.map(&:to_i)}
      else
        []
      end
    end
  end
end
