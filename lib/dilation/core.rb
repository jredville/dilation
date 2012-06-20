require_relative 'utils/events'
require_relative 'utils/counter'
module Dilation
  class Core
    include Utils::Events
    event :tick, :start, :stop, :sleep, :wake

    attr_writer :timer_source
    def initialize
      @counter = Utils::Counter.new
    end

    def dilate(factor = 1)
      @counter.factor = factor
      @counter.invert
    end

    def contract(factor = 1)
      @counter.factor = factor
      @counter.uninvert
    end

    def tick
      @counter.run { __tick }
    end

    def start
      timer.start
      __start
    end

    def stop
      timer.stop
      __stop
    end

    def timer
      @timer ||= timer_source.call(self)
    end

    private
    def timer_source
      @timer_source ||= lambda { |obj| Timers::Coarse.new(obj) }
    end
  end
end