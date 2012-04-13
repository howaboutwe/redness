require 'spec_integration_helper'

describe RedJSON do
  describe ".set and .get" do
    it "stores json at the provided key" do
      RedJSON.set("test", [1,2,3])
      RedJSON.get("test").should == [1,2,3]
    end
  end
end
