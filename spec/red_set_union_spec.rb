require 'spec_integration_helper'

describe RedSetUnion do
  describe ".new" do
    it "returns an instance of RedMultiSet with keys set" do
      r = RedSetUnion.new("key1", "key2", "key3")
      r.keys.should == ["key1", "key2", "key3"]
    end
  end

  describe "#get" do
    context "RedSet" do
      before do
        RedSet.add("key1", 1)
        RedSet.add("key1", 2)
        RedSet.add("key1", 3)

        RedSet.add("key2", 1)
        RedSet.add("key2", 6)
        RedSet.add("key2", 7)

        RedSet.add("key3", 9)
      end

      it "returns an array with all of the unique values ordered by score" do
        r = RedSetUnion.new("key1", "key2", "key3")
        r.get.should == [7,3,6,2,9,1]
      end

      context "with non existent key" do
        it "does not return nils" do
          r = RedSetUnion.new("key1", "key2", "key3", "nonexistent")
          r.get.should == [7,3,6,2,9,1]
        end
      end
    end

    context "TimedRedSet" do
      before do
        TimedRedSet.add("key1", 1)
        TimedRedSet.add("key1", 2)
        TimedRedSet.add("key1", 3)

        TimedRedSet.add("key2", 1)
        TimedRedSet.add("key2", 6)
        TimedRedSet.add("key2", 7)

        TimedRedSet.add("key3", 9)
      end

      it "returns an array with all of the unique values ordered by score" do
        r = RedSetUnion.new("key1", "key2", "key3")
        r.get.should == [1,9,7,6,3,2]
      end

      context "with non existent key" do
        it "does not return nils" do
          r = RedSetUnion.new("key1", "nonexistent", "key2", "key3")
          r.get.should == [1,9,7,6,3,2]
        end
      end
    end
  end
end
