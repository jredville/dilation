require 'celluloid'
require_relative 'timer'

Celluloid.logger = nil

module Dilation
  module Timers
    # A Celluloid based timer that is the default for Dilation::Core
    # @see http://celluloid.io/
    #
    # @author Jim Deville <james.deville@gmail.com>
    class Coarse < Timer
      include Celluloid

      # Stop this timer
      def stop
        defined?(@timer) && @timer.cancel
        super
      end

      # Start this timer, ticking every second
      def start
        @timer = every(1) { tick }
        super
      end
    end
  end
end