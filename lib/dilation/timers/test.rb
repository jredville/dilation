require_relative 'timer'

module Dilation
  module Timers
    # A test timer that does not fire by itself. Primarily meant to
    # be used inside of tests so you can control the passage of time
    #
    # @author Jim Deville <james.deville@gmail.com>
    # @todo make this default for tests
    class Test < Timer
    end
  end
end