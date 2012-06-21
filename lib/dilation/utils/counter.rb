module Dilation
  module Utils
    class Counter
      attr_writer :factor
      def initialize
        self.factor = 1
      end

      def factor=(val)
        @factor = val
        reset
      end

      def invert
        @invert = true
        reset
      end

      def uninvert
        @invert = false
        reset
      end

      def inverted?
        defined?(@invert) && @invert
      end

      def reset
        @count = 0
      end

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