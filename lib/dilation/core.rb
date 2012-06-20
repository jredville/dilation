require_relative 'utils/events'
module Dilation
  class Core
    include Utils::Events
    event :tick, :start, :stop, :sleep, :wake

    attr_writer :timer_source
    def initialize
      dilate(1)
      @count = 0
    end

    def dilate(factor = 1)
      @contraction = 1
      @dilation = factor
    end

    def contract(factor = 1)
      @dilation = 1
      @contraction = factor
    end

    def tick
      @count += 1
      if @count == @dilation
        @contraction.times { __tick }
        @count = 0
      end
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