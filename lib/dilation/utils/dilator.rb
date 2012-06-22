module Dilation
  module Utils
    # This class is used for controlling the dilation and contraction
    # factors of Core
    #
    # @author Jim Deville <james.deville@gmail.com>
    # @todo Fix floating point issue (see specs)
    class Dilator
      def initialize
        self.factor = 1
      end

      # Set the factor and reset the dilator
      #
      # @param [Number] val the new factor
      def factor=(val)
        @factor = val
        reset
      end

      # Invert the dilator. When inverted, `factor` calls to {#run}
      # yield once. Also resets the dilator
      #
      # @see {#run}
      def invert
        @invert = true
        reset
      end

      # Uninvert the dilator. When uninverted, one call to {#run}
      # yield `factor` times. Also resets the dilator
      #
      # @see {#run}
      def uninvert
        @invert = false
        reset
      end

      # @return [Boolean] true if this dilator is inverted
      def inverted?
        defined?(@invert) && @invert
      end

      # Reset this dilator
      # @todo should this be public?
      def reset
        @count = 0
      end

      # Run ths dilator based on the factor
      #
      # @yield if the factor is met
      # @see {#invert}
      # @see {#uninvert}
      def run(&blk)
        begin
          blk.call
        end while run_again? if ready?
      end

      private
      def ready?
        @count += factor
        @count >= 1
      end

      def factor
        @invert ? 1/@factor.to_f : @factor
      end

      def run_again?
        @count -= 1
        if @count < 1
          return false
        end
        true
      end
    end
  end
end