module Dilation
  module Timers
    # @abstract Subclass and override {#start} and {#stop}
    #
    # @author Jim Deville <james.deville@gmail.com>
    class Timer
      # @param [#tick] target the object to notify on ticks
      def initialize(target)
        @target = target
      end

      # This method should be called by subclasses on each tick
      def tick
        @target.tick
      end

      # @return [Boolean] true if this timer is running
      def running?
        defined?(@started) && @started
      end

      # Stop this timer
      def stop
        @started = false
      end

      # Start this timer
      def start
        @started = true
      end
    end
  end
end