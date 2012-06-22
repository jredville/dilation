module Dilation
  module Utils
    # Defines an event handler system loosely based off of the DOM
    # addEventListener pattern
    #
    # @example
    #   class Foo
    #     include Dilation::Utils::Events
    #     event :bar, :baz
    #     def baz
    #       bar
    #       __baz
    #     end
    #   end
    #   f = Foo.new
    #   f.listen_for :bar, { puts 'bar' }
    #   f.listen_for :baz, { puts 'baz' }
    #   f.baz #=> prints bar then baz
    #
    # @author Jim Deville <james.deville@gmail.com>
    # @todo fix return types
    module Events
      # @private
      def self.included(base)
        base.send :extend, ClassMethods
      end

      module ClassMethods
        # Defines one or more events with the name and the __name variant
        #
        # @param [Array<String>, Array<Symbol>] names the names of the events to create
        def event(*names)
          names.each do |name|
            define_method(name) { fire name }
            alias_method :"__#{name}", name
          end
        end
      end

      # Registers a block or callable for the given event
      #
      # @overload listen_for(name, handler)
      #   registers the handler for the event
      #   @param [String, Symbol, #to_sym] name the event to listen for
      #   @param [#call] handler the handler to trigger for this event
      # @overload listen_for(name, &blk)
      #   registers the block for the event
      #   @param [String, Symbol, #to_sym] name the event to listen for
      #   @param blk the block to trigger for this event
      # @raise ArgumentError if handler or blk is not present
      def listen_for(name, handler = nil, &blk)
        to_add = handler || blk
        raise ArgumentError.new "handler or block required" unless to_add
        handlers[name.to_sym] << to_add
      end

      # Removes a callable for the given event
      #
      # @param [String, Symbol, #to_sym] name the event to remove from
      # @param [#call] handler the handler to remove
      def dont_listen_for(name, handler)
        handlers[name.to_sym].delete(handler)
      end

      # Clears all handlers for the event
      #
      # @param [String, Symbol, #to_sym] name the event to clear
      def clear(name)
        handlers[name.to_sym] = []
      end

      # Clear all tracked handlers
      def clear_all
        self.handlers = Hash.new { |h, k| h[k] = [] }
      end

      # Triggers the given event
      #
      # @param [String, Symbol, #to_sym] name event to trigger
      def fire(name)
        handlers[name.to_sym].each(&:call)
      end

      private
      attr_writer :handlers
      def handlers
        @handlers || clear_all
      end
    end
  end
end