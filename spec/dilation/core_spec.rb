require 'spec_mini'
require 'dilation/core'

describe Dilation::Core do
  let(:core) { Dilation::Core.new }

  subject { core }

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