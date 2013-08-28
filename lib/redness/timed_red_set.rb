class TimedRedSet < RedSet

  def self.add(key, member)
    super(key, member, :score => lambda { Precisionable.int_from_float(Time.now) })
  end

  def self.since(key, start, options={})
    precise_start = Precisionable.int_from_float(start)

    redis.execute_with_uncertainty([]) do
      raw = redis.zrevrangebyscore(key, "+inf", precise_start, with_scores: options[:with_scores])

      if options[:upper] and options[:lower]
        lower = options[:lower].to_i
        upper = options[:upper].to_i

        raw = raw[lower..upper]
      end

      if options[:with_scores]
        result = {}
        raw.each do |member, score|
          result[member.to_i] = Time.at(Precisionable.float_from_int(score))
        end
        result
      else
        raw.map(&:to_i)
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
