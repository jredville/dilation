module Dilation
  module TestSupport
    # A handler that can be used in tests to confirm that events are hooked up
    #
    # @example Rspec example
    #   describe "Example" do
    #     let(:handler) { Dilation::TestSupport::Handler.new }
    #     subject { MyCoreBasedClass.new }
    #
    #     it "triggers handler" do
    #       subject.listen_for :tick, handler
    #       subject.tick
    #       handler.should be_triggered
    #     end
    #   end
    #
    # @author Jim Deville <james.deville@gmail.com>
    class Handler
      # @return [Number] the number of times triggered
      attr_reader :count

      def initialize
        @count = 0
      end

      # Trigger this handler
      # @note increments the counter
      #
      # @return [Number] the new count
      def call
        @count += 1
      end

      # @return [Boolean] true if this handler has been called
      def triggered?
        @count > 0
      end
    end
  end
end