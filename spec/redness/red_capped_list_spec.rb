require 'spec_integration_helper'

describe RedCappedList do
  describe ".new" do
    it "returns an instance of RedCappedList with cap and key set" do
      r = RedCappedList.new("somekey", 1000)
      r.key.should == "somekey"
      r.cap.should == 1000
    end
  end

  describe "#get" do
    it "returns the list at the key" do
      r = RedCappedList.new("somekey", 1000)
      r.get.should == []
    end
  end

  describe "#get_strings" do
    it "returns the string values of the list at the key" do
      r = RedCappedList.new("somekey", 2)

      r.get_strings.should == []

      r.add("foo")
      r.add("bar")
      r.add("baz")

      r.get_strings.should == ["baz", "bar"]
    end
  end

  describe "#add" do
    it "adds to the list at the key" do
      r = RedCappedList.new("somekey", 1000)
      r.add(1)
      r.get.should == [1]
    end

    it "keeps the collection capped at the cap" do
      r = RedCappedList.new("somekey", 1)
      r.add(1)
      r.get.should == [1]
      r.add(2)
      r.get.should == [2]
    end
  end
end
