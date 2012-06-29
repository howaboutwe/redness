require 'spec_integration_helper'

describe RedHash do
  let(:red_hash) { RedHash.new("configuration") }

  describe ".new" do
    it "returns a red hash whose hash key is set to the first parameter" do
      r = RedHash.new("test")
      r.hash_key.should == "test"
    end

    it "uses the class name as the default hash key if no parameter is passed" do
      r = RedHash.new
      r.hash_key.should == "RedHash"
    end
  end

  describe "#[]=" do
    it "sets a key" do
      red_hash[:key] = "value"
      red_hash[:key].should == "value"
    end
  end

  describe "#[]" do
    it "gets a key" do
      red_hash[:key] = "value"
      red_hash[:key].should == "value"
    end

    it "returns nil if the key does not exist" do
      red_hash[:non_key].should be_nil
    end

    it "should get different values depending on hash_key" do
      red_hash[:key] = "value"

      another_hash = RedHash.new("another_hash")
      another_hash[:key] = "value2"

      red_hash[:key].should == "value"
      another_hash[:key].should == "value2"
    end
  end

  describe "#all" do
    it "gets the entire hash" do
      red_hash[:key] = "value"
      red_hash[:another_key] = "another_value"

      red_hash.all.should == {
        "key"         => "value",
        "another_key" => "another_value"
      }
    end
  end

  describe "#remove" do
    it "removes a key" do
      red_hash[:key] = "value"
      red_hash[:key].should == "value"

      red_hash.remove(:key)
      red_hash[:key].should be_nil
    end
  end

  describe "#clear" do
    it "removes all keys" do
      red_hash[:key] = "value"
      red_hash[:another_key] = "another_value"

      red_hash.clear
      red_hash.all.should == {}
    end
  end

  describe "#get" do
    before do
      red_hash.set(
        key: "foo",
        another: "bar",
        yet_another: "baz"
      )
    end

    it "is aliased to []" do
      red_hash.should_receive(:[]).with("key").and_return("foo")

      red_hash.get("key").should == "foo"
    end
  end

  describe "#set" do
    it "accepts a hash, and sets all keys" do
      red_hash.set(
        :key => "something",
        :another_key => "something_else"
      )

      red_hash["another_key"].should == "something_else"
      red_hash["key"].should == "something"
    end
  end
end
