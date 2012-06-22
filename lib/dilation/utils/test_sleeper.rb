require_relative 'sleeper'

module Dilation
  module Utils
    # A Sleeper for use in tests. While the normal sleeper with
    # contraction could be used, this feels cleaner
    #
    # @note this Sleeper's #wait method does not block
    #
    # @see Dilation::Utils::Sleeper
    #
    # @author Jim Deville <james.deville@gmail.com>
    class TestSleeper < Sleeper
      # Called to simulate waiting. Does not block
      #
      # @param [Number] time the time to wait in seconds
      def wait(time)
      end
    end
  end
end