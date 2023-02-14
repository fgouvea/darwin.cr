require "../spec_helper"

describe StubProcessor do
    describe "#process" do
        it "should just count number of calls" do
            processor = StubProcessor(Int32).new

            processor.times_called.should eq 0

            #TODO
        end
    end
end