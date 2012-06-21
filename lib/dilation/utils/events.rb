module Dilation
  module Utils
    module Events
      def self.included(base)
        base.send :extend, ClassMethods
      end

      def listen_for(type, handler = nil, &blk)
        to_add = handler || blk
        raise ArgumentError.new "handler or block required" unless to_add
        handlers[type.to_sym] << to_add
      end

      def dont_listen_for(type, handler)
        handlers[type.to_sym].delete(handler)
      end

      def clear(type)
        handlers[type.to_sym] = []
      end

      def clear_all
        self.handlers = Hash.new { |h, k| h[k] = [] }
      end

      def fire(name)
        handlers[name.to_sym].each(&:call)
      end

      private
      attr_writer :handlers
      def handlers
        @handlers || clear_all
      end

      module ClassMethods
        def event(*names)
          names.each do |name|
            define_method(name) { fire name }
            alias_method :"__#{name}", name
          end
        end
      end
    end
  end
end