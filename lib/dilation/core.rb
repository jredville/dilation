require_relative 'utils/events'
require_relative 'utils/dilator'
require_relative 'timers/coarse'

module Dilation
  # Dilation::Core is the main object that allows you to interact
  # with and test timers.
  #
  # @author Jim Deville <james.deville@gmail.com>
  # @todo better interface to swap the timer
  class Core
    include Utils::Events
    event :tick, :start, :stop, :sleep, :wake

    # @param [#call] value The factory for the timer
    attr_writer :timer_source

    def initialize
      @dilator = Utils::Dilator.new
    end

    # Slows down (dilates) time for your code
    #
    # @example Run at half time
    #   core.dilate(2)
    #   core.tick #=> nothing
    #   core.tick #=> fires tick event
    #
    # @overload dilate
    #   Sets a factor of 1 which is the same as no dilation
    # @overload dilate(factor)
    #   Sets a factor of `factor` which implies one `Core#tick` per
    #     `factor` `Core#timer` ticks
    #   @param [Number] factor the dilation factor
    # @return [Number] the dilation factor
    # @see Dilation::Utils::Dilator
    def dilate(factor = 1)
      @dilator.factor = factor
      @dilator.invert
      factor
    end

    # Speeds up (contracts) time for your code
    #
    # @example Run at 2x time
    #   core.contract(2)
    #   core.tick #=> fires 2 tick events
    #
    # @overload contract
    #   Sets a factor of 1 which is the same as no contraction
    # @overload contract(factor)
    #   Sets a factor of `factor` which implies `factor` `Core#tick`s
    #     per one `Core#timer` tick
    #   @param [Number] factor the contraction factor
    # @return [Number] the contraction factor
    # @see Dilation::Utils::Dilator
    def contract(factor = 1)
      @dilator.factor = factor
      @dilator.uninvert
      factor
    end

    # @private
    # Called by the timer on each tick. Fires tick events based on
    #   the dilation/contraction factor
    #
    # @see #dilate
    # @see #contract
    def tick
      if started?
        @dilator.run { __tick }
      end
    end

    # Starts the timer and fires the start event
    def start
      timer.start
      @started = true
      __start
    end

    # Stops the timer and fires the stop event
    def stop
      timer.stop
      @started = false
      __stop
    end

    # Sleeps for `time` (based on Core#tick).
    #
    # @note This method blocks the caller
    #
    # @example Sleep for 5 seconds
    #   core.sleep 5 #=> 5
    # @example Sleep for 1 second
    #   core.sleep #=> 1
    # @overload sleep(time)
    #   Sleep for the given number of second
    #   @param [Number] time the time to sleep for in seconds
    # @overload sleep
    #   Sleep for 1 second
    # @return [Number] time
    def sleep(time=1)
      sleep_handler = lambda { time -= 1}
      listen_for :tick, sleep_handler
      __sleep
      start
      while time > 0
      end
      stop
      wake
      time
    ensure
      dont_listen_for :tick, sleep_handler
    end

    # @return [Timer] the timer object for this core
    #
    # @see Dilation::Timers::Coarse
    def timer
      @timer ||= timer_source.call(self)
    end

    # @todo does this need to be public?
    # @return [Boolean] is this core started or not
    def started?
      defined?(@started) && @started
    end

    private
    def timer_source
      @timer_source ||= lambda { |obj| Timers::Coarse.new(obj) }
    end
  end
end