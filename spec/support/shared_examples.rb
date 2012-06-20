require 'dilation/test_support/handler'

shared_context "core event" do
  let(:handler) { Dilation::TestSupport::Handler.new }
  let(:handler2) { Dilation::TestSupport::Handler.new }
end

shared_examples "a core event" do |event_name, trigger|
  it_behaves_like "a core event details", event_name, trigger
  it_behaves_like "a core event details", event_name, "__#{trigger}"
end

shared_examples "a core event details" do |event_name, trigger|
  include_context "core event"

  it "can trigger without handlers" do
    expect { subject.send trigger }.to_not raise_error
  end

  it "can be subscribed via #listen_for with :#{event_name}" do
    subject.listen_for event_name, handler
    expect { subject.send trigger }.to trigger(handler)
  end

  it "can be subscribed multiple times via #listen_for with :#{event_name}" do
    subject.listen_for event_name, handler
    subject.listen_for event_name.to_s, handler2
    expect { subject.send trigger }.to trigger(handler).and_also(handler2)
  end

  it "works after clearing listeners" do
    subject.listen_for event_name, handler
    subject.clear event_name
    subject.listen_for event_name, handler2
    expect { subject.send trigger }.to trigger(handler2).but_not(handler)
  end

  it "works after clearing all listeners" do
    subject.listen_for event_name, handler
    subject.clear_all
    subject.listen_for event_name, handler2
    expect { subject.send trigger }.to trigger(handler2).but_not(handler)
  end
end