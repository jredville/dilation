module Dilation
  module Timers
    class Test
      def initialize(target)
        @target = target
      end

      def tick
        @target.tick
      end

      def running?
        defined?(@started) && @started
      end

      def stop
        @started = false
      end

      def start
        @started = true
      end
    end
  end
end