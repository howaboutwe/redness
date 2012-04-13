require 'spec_integration_helper'

describe RedSet do
  describe ".add" do
    it "should add a member to the set" do
      RedSet.add("somekey", 2)
      set = RedSet.get("somekey")

      set.should == [2]
    end

    it "should not add duplicates to the set" do
      RedSet.add("somekey", 2)
      RedSet.add("somekey", 2)

      set = RedSet.get("somekey")

      set.should == [2]
    end

    it "should not change the order of the set on attempted duplicate" do
      RedSet.add("somekey", 2)
      RedSet.add("somekey", 3)
      RedSet.add("somekey", 2)

      set = RedSet.get("somekey")

      set.should == [3,2]
    end

    it "sets the score when one is provided" do
      RedSet.add("somekey", 1, :score => lambda { 1000 })

      RedSet.score("somekey", 1).should == "1000"
    end
  end

  describe ".remove" do
    it "should remove a member from the set" do
      RedSet.add("somekey", 1)
      RedSet.add("somekey", 2)

      RedSet.remove("somekey", 2)

      RedSet.get("somekey").should == [1]
    end
  end

  describe ".score" do
    it "returns the score of member within key" do
      RedSet.add("somekey", 1)

      RedSet.score("somekey", 1).should == "0"
    end
  end

  describe ".get" do
    describe "pagination" do
      it "should return results bounded by provided options" do
        RedSet.add("somekey", 1)
        RedSet.add("somekey", 2)

        RedSet.get("somekey", :lower => 0, :upper => 0).should == [2]
        RedSet.get("somekey", :lower => 1, :upper => 1).should == [1]
      end
    end
  end

  describe ".count" do
    it "should return the total count" do
      7.times {|i| RedSet.add("somekey",i)}

      RedSet.count("somekey").should == 7
    end
  end
end
