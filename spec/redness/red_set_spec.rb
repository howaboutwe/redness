require 'spec_integration_helper'

describe RedSet do
  describe "#initialize" do
    it "creates a new RedSet instance and stores the key" do
      set = RedSet.new("somekey")

      set.key.should == "somekey"
    end
  end

  describe "#add" do
    it "adds the given value to the set" do
      set = RedSet.new("somekey")

      set.add(1)

      set.value.should == [1]
    end
  end

  describe "#value" do
    it "returns the RedSet collection" do
      set = RedSet.new("somekey")
      set.value.should == []

      set.add(1)

      set.value.should == [1]
    end
  end

  describe "#remove" do
    it "removes the item from the set" do
      set = RedSet.new("somekey")
      set.add(1)
      set.add(2)

      set.value.should == [2, 1]

      set.remove(2)

      set.value.should == [1]
    end
  end

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

    context "when the score responds to #call" do
      it "sets the score when one is provided" do
        RedSet.add("somekey", 1, :score => lambda { 1000 })

        RedSet.score("somekey", 1).should == 1000
      end
    end

    context "the score is anything else" do
      it "sets the score when one is provided" do
        RedSet.add("somekey", 1, score: 20)

        RedSet.score("somekey", 1).should == 20
      end
    end
  end

  describe ".cap" do
    it "caps the set at the given size, dropping earlier elements" do
      RedSet.add('key', 4)
      RedSet.add('key', 1)
      RedSet.add('key', 3)
      RedSet.add('key', 2)

      RedSet.cap('key', 2)

      RedSet.get('key').to_set.should == Set[2, 3]
    end

    it "does nothing if the set is smaller than the given size" do
      RedSet.add('key', 1)
      RedSet.cap('key', 2)
      RedSet.get('key').should == [1]
    end

    it "does nothing if the set does not exist" do
      RedSet.cap('key', 2)
      RedSet.get('key').should == []
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

      RedSet.score("somekey", 1).should == 0
    end
  end

  describe ".get" do
    it "should return the elements in reverse-inserted order" do
      RedSet.add('somekey', 1)
      RedSet.add('somekey', 2)
      RedSet.add('somekey', 3)

      RedSet.get('somekey').should == [3, 2, 1]
    end

    it "should pair the elements with their scores if :with_scores is true" do
      RedSet.add('somekey', 1)
      RedSet.add('somekey', 2)
      RedSet.add('somekey', 3)

      RedSet.get('somekey', :with_scores => true).should == [[3, 2], [2, 1], [1, 0]]
    end

    it "should return results bounded by provided pagination options" do
      RedSet.add("somekey", 1)
      RedSet.add("somekey", 2)

      RedSet.get("somekey", :lower => 0, :upper => 0).should == [2]
      RedSet.get("somekey", :lower => 1, :upper => 1).should == [1]
    end
  end

  describe ".count" do
    it "should return the total count" do
      7.times {|i| RedSet.add("somekey",i)}

      RedSet.count("somekey").should == 7
    end
  end
end
