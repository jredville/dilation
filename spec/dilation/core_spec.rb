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

  context "timer" do
    before do
      subject.timer #HACK :(: Need to hook up the timer
    end

    it "starts timer when start is called" do
      timer.should_receive(:start)
      subject.start
    end

    it "stops timer when stop is called" do
      timer.should_receive(:stop)
      subject.stop
    end

    it "gets tick called by the timer" do
      subject.listen_for :tick, handler
      expect { timer.tick }.to trigger(handler)
    end
  end

  context "dilation" do
    before do
      subject.timer #HACK :(: Need to hook up the timer
      subject.listen_for :tick, handler
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
      it_behaves_like "a core event", :tick, :tick
    end

    context "start" do
      it_behaves_like "a core event", :start, :start
    end

    context "stop" do
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