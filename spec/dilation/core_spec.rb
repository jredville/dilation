require 'spec_mini'
require 'dilation/core'
require 'dilation/timers/test'
require 'dilation/utils/test_sleeper'

describe Dilation::Core do
  let(:core) { Dilation::Core.new }
  let(:timer) { Dilation::Timers::Test.new(subject) }
  let(:sleeper) { Dilation::Utils::TestSleeper.new }

  include_context "core event"

  subject do
    core.tap do |c|
      c.timer_source = lambda { |o| timer }
      c.sleeper_source = lambda { sleeper }
    end
  end

  context "starting" do
    it "starts timer when start is called" do
      timer.should_receive(:start)
      subject.start
    end

    it "gets ticks after timer is started" do
      subject.listen_for :tick, handler

      subject.start
      expect { timer.tick }.to trigger(handler)
    end

    it "ignores multiple start calls" do
      subject.listen_for :start, handler
      subject.start
      subject.start
      handler.count.should == 1
    end
  end

  context "stopping" do
    before do
      timer.stub(:running?).and_return(true, false)
    end

    it "stops timer when stop is called" do
      timer.should_receive(:stop)
      subject.stop
    end

    it "ignores multiple stop calls" do
      timer.should_receive(:stop).once
      subject.stop
      subject.stop
    end

    it "stop when not started is ignored" do
      timer.stub(:running? => false)
      timer.should_not_receive(:stop)
      subject.stop
    end
  end

  context "timer" do
    before do
      subject.listen_for :tick, handler
    end

    it "gets tick called by the timer" do
      subject.start
      expect { timer.tick }.to trigger(handler)
    end

    it "does not get ticks before timer is started" do
      expect { timer.tick }.not_to trigger(handler)
    end

    it "does not get ticks after timer is stopped" do
      subject.start
      subject.stop
      expect { timer.tick }.not_to trigger(handler)
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
      before do
        subject.start
      end
      it_behaves_like "a core event", :stop, :stop
    end

    context "sleep" do
      it_behaves_like "a core event", :sleep, :sleep
    end

    context "wake" do
      it_behaves_like "a core event", :wake, :wake
    end
  end
end