module Dilation
  module TestSupport
    class Handler
      attr_reader :count
      def initialize
        @count = 0
      end

      def call
        @count += 1
      end

      def triggered?
        @count > 0
      end
    end
  end
end