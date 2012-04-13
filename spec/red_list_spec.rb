require 'spec_integration_helper'

describe RedList do
  describe ".add" do
    it "adds a member to the list" do
      RedList.add("somekey", 2)
      list = RedList.get("somekey")

      list.should == [2]
    end

    it "allows duplicates in the list" do
      RedList.add("somekey", 2)
      RedList.add("somekey", 2)

      list = RedList.get("somekey")
      list.should == [2,2]
    end
  end

  describe ".remove" do
    it "removes all matching values in list" do
      RedList.add("somekey", 2)
      RedList.add("somekey", 3)
      RedList.add("somekey", 2)

      RedList.remove("somekey", 2)
      list = RedList.get("somekey")
      list.should == [3]
    end

    context "supplied count" do
      it "removes first {count} occurrences of value in list" do
        RedList.add("somekey", 2)
        RedList.add("somekey", 3)
        RedList.add("somekey", 2)

        RedList.remove("somekey", 2, 1)
        list = RedList.get("somekey")
        list.should == [3, 2]
      end
    end
  end

  describe ".get" do
    it "returns the list in that key" do
      RedList.add("somekey", 1)
      RedList.add("somekey", 2)

      RedList.get("somekey").should == [2,1]
    end
  end

  describe ".count" do
    it "returns the number of occurrences of the value within the list" do
      RedList.add("somekey", 1)
      RedList.add("somekey", 1)
      RedList.add("somekey", 2)

      RedList.count("somekey", 1).should == 2
    end
  end

  describe ".total_size" do
    it "retuns the total size of the array (list)" do
      RedList.total_size("foobar").should == 0
      RedList.add("foobar","a")
      RedList.total_size("foobar").should == 1
      RedList.add("foobar","b")
      RedList.total_size("foobar").should == 2
    end
  end

  describe ".pop" do
    it "removes the last element in the list" do
      RedList.add("foobar2", "a")
      RedList.add("foobar2", "b")
      RedList.add("foobar2", "c")

      RedList.redis.lrange("foobar2", 0, -1).should == ["c", "b", "a"]
      RedList.pop("foobar2").should == "a"
      RedList.redis.lrange("foobar2", 0, -1).should == ["c", "b"]
    end
  end

  describe ".trim_to" do
    it "removes elements from the list until {amount} remain" do
      RedList.add("somekey", 1)
      RedList.add("somekey", 2)
      RedList.add("somekey", 3)

      RedList.trim_to("somekey", 1)
      RedList.get("somekey").should == [3]
    end
  end
end
