require 'celluloid'

module Dilation
  module Timers
    class Coarse
      include Celluloid
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
        defined?(@timer) && @timer.cancel
      end

      def start
        @started = true
        @timer = every(1) { tick }
      end
    end
  end
end