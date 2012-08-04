require_relative '../spec_integration_helper'

describe Red do
  describe "#execute_with_uncertainty" do
    it "should return the given value if the block raises a Red::RedisUnavailable" do
      Red.new.execute_with_uncertainty(:boom) { raise Red::RedisUnavailable }.should == :boom
    end

    it "should return the given value if the block raises a Redis::CannotConnectError" do
      Red.new.execute_with_uncertainty(:boom) { raise Redis::CannotConnectError }.should == :boom
    end

    it "should return the given value if the block raises a Redis::TimeoutError" do
      Red.new.execute_with_uncertainty(:boom) { raise Redis::TimeoutError }.should == :boom
    end
  end

  describe "#multi_with_caution" do
    context "when the multi fails" do
      before do
        Red.redis.stub(:multi).and_raise(Redis::TimeoutError)
      end

      it "should return the failure result given, if any" do
        Red.new.multi_with_caution(:boom){}.should == :boom
      end

      it "should return an empty array if no failure result is given" do
        Red.new.multi_with_caution { raise error_class }.should == []
      end

      it "should not call discard" do
        lambda do
          Red.new.multi_with_caution{}
        end.should_not raise_error
      end
    end

    describe "when the block raises an exception" do
      let(:error_class) { Class.new(RuntimeError) }

      it "should return the failure result given, if any" do
        Red.new.multi_with_caution(:boom) { raise error_class }.should == :boom
      end

      it "should return an empty array if no failure result is given" do
        Red.new.multi_with_caution { raise error_class }.should == []
      end

      it "should discard the transaction" do
        Red.redis.should_receive(:multi)
        Red.redis.should_not_receive(:exec)
        Red.redis.should_receive(:discard)
        begin
          Red.new.multi_with_caution{raise error_class}
        rescue error_class
        end
      end
    end

    context "when the block does not raise an exception" do
      it "should exec the transaction" do
        Red.redis.should_receive(:multi)
        Red.redis.should_receive(:exec)
        Red.redis.should_not_receive(:discard)
        Red.new.multi_with_caution{}
      end

      it "should return the results of the exec'd commands" do
        result = Red.new.multi_with_caution do
          Red.redis.set('a', 1)
          Red.redis.set('b', 1)
        end
        result.size.should == 2
      end
    end
  end
end
