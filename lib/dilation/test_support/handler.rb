module Dilation
  module TestSupport
    class Handler
      def initialize
        @triggered = false
      end

      def call
        @triggered = true
      end

      def triggered?
        @triggered
      end
    end
  end
end