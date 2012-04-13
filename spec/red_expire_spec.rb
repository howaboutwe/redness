require 'spec_integration_helper'

describe RedExpire do
  describe ".set" do
    it "expires the key in the given seconds" do
      RedJSON.set('test', 1)
      RedExpire.set('test', 0.seconds)
      RedJSON.get('test').should be_nil
    end
  end
end
