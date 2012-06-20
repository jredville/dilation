module Dilation
  module Utils
    class Counter
      attr_writer :factor
      def initialize
        @count = 0
        @factor = 1
        @invert = false
      end

      def factor=(val)
        @factor = val
        @count = 0
      end

      def invert
        @invert = true
      end

      def uninvert
        @invert = false
      end

      def inverted?
        @invert
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