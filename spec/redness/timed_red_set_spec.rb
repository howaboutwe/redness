require 'spec_integration_helper'

describe TimedRedSet do
  describe ".add" do
    it "adds a member to the set" do
      TimedRedSet.add("somekey", 1)

      set = TimedRedSet.get("somekey")

      set.should == [1]
    end

    it "adds a member to the set with a timestamp for score" do
      the_time = Time.now
      Timecop.freeze(the_time) do
        TimedRedSet.add("somekey", 1)

        TimedRedSet.score("somekey", 1).to_s.should == the_time.to_s
      end
    end
  end

  describe ".since" do
    it "returns the additions since a start time" do
      the_past = 2.days.ago

      Timecop.freeze(the_past) do
        TimedRedSet.add("somekey", 1)
      end

      TimedRedSet.add("somekey", 2)

      TimedRedSet.since("somekey", 1.day.ago).should == [2]
    end

    it "returns results sorted in reverse chronological order" do
      the_past = 2.days.ago

      Timecop.freeze(the_past) do
        TimedRedSet.add("somekey", 1)
      end

      TimedRedSet.add("somekey", 2)

      TimedRedSet.since("somekey", 3.days.ago).should == [2, 1]
    end

    it "accepts an upper and lower bound" do
      TimedRedSet.add("somekey", 1)
      TimedRedSet.add("somekey", 2)
      TimedRedSet.add("somekey", 3)

      TimedRedSet.since("somekey", 1.day.ago, :lower => 0, :upper => 0).should == [3]
      TimedRedSet.since("somekey", 1.day.ago, :lower => 0, :upper => 1).should == [3,2]
      TimedRedSet.since("somekey", 1.day.ago, :lower => 1, :upper => 2).should == [2,1]
    end

    it "returns an array of elmeents with timestamps if the with_scores option is true" do
      Timecop.freeze(Time.at(1.5)) { TimedRedSet.add('somekey', 10) }
      Timecop.freeze(Time.at(2.5)) { TimedRedSet.add('somekey', 20) }
      Timecop.freeze(Time.at(3.5)) { TimedRedSet.add('somekey', 30) }

      TimedRedSet.since('somekey', 2, :with_scores => true).should ==
        {20 => Time.at(2.5), 30 => Time.at(3.5)}
    end

    it "supports using the :upper/:lower and :with_scores attributes together" do
      Timecop.freeze(Time.at(1.5)) { TimedRedSet.add('somekey', 10) }
      Timecop.freeze(Time.at(2.5)) { TimedRedSet.add('somekey', 20) }
      Timecop.freeze(Time.at(3.5)) { TimedRedSet.add('somekey', 30) }

      TimedRedSet.since('somekey', 2, :lower => 1, :upper => 1, :with_scores => true).should ==
        {20 => Time.at(2.5)}
    end
  end

  describe ".get_with_timestamps" do
    it "returns members of the set with times" do
      TimedRedSet.add("somekey", 1)
      TimedRedSet.add("somekey", 2)
      TimedRedSet.add("somekey", 3)

      TimedRedSet.get_with_timestamps("somekey").should == [
        [3, TimedRedSet.score("somekey", 3)],
        [2, TimedRedSet.score("somekey", 2)],
        [1, TimedRedSet.score("somekey", 1)]
      ]
    end

    it "supports pagination" do
      TimedRedSet.add("somekey", 1)
      TimedRedSet.add("somekey", 2)
      TimedRedSet.add("somekey", 3)

      TimedRedSet.get_with_timestamps("somekey", :lower => 0, :upper => 0).should == [
        [3, TimedRedSet.score("somekey", 3)]
      ]
    end
  end
end
