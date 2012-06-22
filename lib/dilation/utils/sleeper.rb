module Dilation
  module Utils
    # A Sleeper is really just an abstraction of a wait loop. Its
    # main reason for existing is to allow easier testing of a Core,
    # which would deadlock with a simple wait loop
    #
    # @example
    #   obj = Dilation::Core.new
    #   sleeper = Sleeper.new
    #   sleeper.with(obj) do |s|
    #     # the object yielded to this block is registered
    #     # with obj's tick event
    #     s.wait(time)
    #   end
    #
    # @author Jim Deville <james.deville@gmail.com>
    class Sleeper
      # @return [#listen_for,#dont_listen_for] the object this sleeper is registered with
      attr_reader :obj

      def initialize
        @counter = 0
      end

      # Hooks up to `obj`s tick event, and yields a sleeper
      #
      # @note the sleeper yielded may not be self in the future
      #
      # @param [#listen_for,#dont_listen_for] obj Object to register with
      #
      # @yieldparam [#wait] sleeper the registered sleeper
      def with(obj)
        registered(obj) do
          yield self
        end
      end

      # Blocks for `time` seconds
      #
      # @param [Number] time the time to wait in seconds
      def wait(time)
        start = @counter
        while @counter - start < time
        end
      end

      private
      # caches the handler for removal
      def ticker
        @ticker ||= lambda { @counter += 1 }
      end

      # registers with object, yields, and ensures we are unregistered
      def registered(obj)
        @obj = obj
        register
        yield
      ensure
        unregister
      end

      def register
        obj.listen_for :tick, ticker
      end

      def unregister
        obj.dont_listen_for :tick, ticker
      end
    end
  end
end