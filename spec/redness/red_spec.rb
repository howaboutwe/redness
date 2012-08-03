require_relative '../spec_integration_helper'

describe Red do
  describe "#multi_with_caution" do
    it "should not try call discard if the multi fails" do
      Red.redis.stub(:multi).and_raise(Redis::TimeoutError)
      red = Red.new
      lambda do
        red.multi_with_caution{}
      end.should_not raise_error
    end

    it "should exec the transaction if the block does not raise an exception" do
      Red.redis.should_receive(:multi)
      Red.redis.should_receive(:exec)
      Red.redis.should_not_receive(:discard)
      Red.new.multi_with_caution{}
    end

    it "should discard the transaction if the block raises an exception" do
      error_class = Class.new(RuntimeError)
      Red.redis.should_receive(:multi)
      Red.redis.should_not_receive(:exec)
      Red.redis.should_receive(:discard)
      begin
        Red.new.multi_with_caution{raise error_class}
      rescue error_class
      end
    end
  end
end
