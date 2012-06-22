require 'spec_mini'
require 'dilation/core'
require 'dilation/timers/test'

describe Dilation::Core do
  let(:core) { Dilation::Core.new }
  let(:timer) { Dilation::Timers::Test.new(subject) }

  include_context "core event"

  subject do
    core.tap do |c|
      c.timer_source = lambda { |o| timer }
    end
  end

  context "starting and stopping" do
    before do
      subject.listen_for :tick, handler
    end

    it "starts timer when start is called" do
      timer.should_receive(:start)
      subject.start
    end

    it "stops timer when stop is called" do
      timer.should_receive(:stop)
      subject.stop
    end

    it "does not get ticks before timer is started" do
      expect { timer.tick }.not_to trigger(handler)
    end

    it "gets ticks after timer is started" do
      subject.start
      expect { timer.tick }.to trigger(handler)
    end

    it "does not get ticks after timer is stopped" do
      subject.start
      subject.stop
      expect { timer.tick }.not_to trigger(handler)
    end

    it "ignores multiple start calls"
    it "ignores multiple stop calls"
    it "stop when not started is ignored"
  end

  context "timer" do
    before do
      subject.start
    end

    it "gets tick called by the timer" do
      subject.listen_for :tick, handler
      expect { timer.tick }.to trigger(handler)
    end
  end

  context "dilation" do
    before do
      subject.listen_for :tick, handler
      subject.start
    end

    it "returns the new factor" do
      subject.dilate.should == 1
      subject.dilate(2).should == 2
      subject.contract.should == 1
      subject.contract(2).should == 2
    end

    it "receives one tick per tick of the timer by default" do
      10.times { timer.tick }
      handler.count.should == 10
    end

    it "dilates time" do
      subject.dilate(2) #2 real ticks per tick
      10.times { timer.tick }
      handler.count.should == 5
    end

    it "defaults to a dilation factor of 1" do
      subject.dilate
      10.times { timer.tick }
      handler.count.should == 10
    end

    it "contracts time" do
      subject.contract(2) #2 ticks for every real tick
      10.times { timer.tick }
      handler.count.should == 20
    end

    it "defaults to a contraction factor of 1" do
      subject.contract
      10.times { timer.tick }
      handler.count.should == 10
    end

    it "resets dilation with contraction" do
      subject.dilate(2)
      subject.contract(2)
      10.times { timer.tick }
      handler.count.should == 20
    end

    it "resets contraction with dilation" do
      subject.contract(2)
      subject.dilate(2)
      10.times { timer.tick }
      handler.count.should == 5
    end
  end

  context "events" do
    context "tick" do
      before do
        subject.start
      end
      it_behaves_like "a core event", :tick, :tick
    end

    context "start" do
      it_behaves_like "a core event", :start, :start
    end

    context "stop" do
      it_behaves_like "a core event", :stop, :stop
    end

    # context "sleep" do
    #   it_behaves_like "a core event", :sleep, :sleep
    # end

    context "wake" do
      it_behaves_like "a core event", :wake, :wake
    end
  end
end