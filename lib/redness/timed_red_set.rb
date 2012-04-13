class TimedRedSet < RedSet
  def self.add(key, member)
    super(key, member, :score => lambda { Precisionable.int_from_float(Time.now) })
  end

  def self.since(key, start, options={})
    precise_start = Precisionable.int_from_float(start)

    redis.execute_with_uncertainty([]) do
      if options[:upper] and options[:lower]
        lower = options[:lower].to_i
        upper = options[:upper].to_i

        redis.zrevrangebyscore(key, "+inf", precise_start)[lower..upper].map(&:to_i)
      else
        redis.zrevrangebyscore(key, "+inf", precise_start).map(&:to_i)
      end
    end
  end

  def self.score(key, member)
    precise_time = super
    Time.at(Precisionable.float_from_int(precise_time)) if precise_time
  end

  def self.get_with_timestamps(key, options = {})
    get(key, options.merge({
        :with_scores => true,
        :scoring => lambda {|x| Time.at(Precisionable.float_from_int(x))}
      })
    )
  end
end
