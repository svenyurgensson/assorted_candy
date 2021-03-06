# Taken from https://github.com/bhuga/promising-future/blob/master/lib/promise.rb

##
# A delayed-execution promise.  Promises are only executed once.
#
# @example
#   x = promise { factorial 20 }
#   y = promise { fibonacci 10**6 }
#   a = x + 1     # => factorial 20 + 1 after factorial calculates
#   result = promise { a += y }
#   abort ""      # whew, we never needed to calculate y
#
# @example
#   y = 5
#   x = promise { y = y + 5 }
#   x + 5     # => 15
#   x + 5     # => 15
#

module AssortedCandy
  module Concurrency

    class Promise < defined?(BasicObject) ? BasicObject : ::Object
      NOT_SET = ::Object.new.freeze

      instance_methods.each { |m| undef_method m unless m =~ /^(__.*|object_id)$/ }

      ##
      # Creates a new promise.
      #
      # @example Lazily evaluate a database call
      #   result = promise { @db.query("SELECT * FROM TABLE") }
      #
      # @yield  [] The block to evaluate lazily.
      # @see    Kernel#promise
      def initialize(&block)
        if block.arity > 0
          ::Kernel.raise ::ArgumentError, "Cannot store a promise that requires an argument"
        end
        @block  = block
        @mutex  = ::Mutex.new
        @result = NOT_SET
        @error  = NOT_SET
      end

      ##
      # Force the evaluation of this promise immediately
      #
      # @return [Object]
      def __force__
        @mutex.synchronize do
          if @result.equal?(NOT_SET) && @error.equal?(NOT_SET)
            begin
              @result = @block.call
            rescue ::Exception => e
              @error = e
            end
          end
        end if @result.equal?(NOT_SET) && @error.equal?(NOT_SET)
        # BasicObject won't send raise to Kernel
        @error.equal?(NOT_SET) ? @result : ::Kernel.raise(@error)
      end
      alias_method :force, :__force__

      ##
      # Does this promise support the given method?
      #
      # @param  [Symbol]
      # @return [Boolean]
      def respond_to?(method)
        :force.equal?(method) || :__force__.equal?(method) || __force__.respond_to?(method)
      end

      private

      def method_missing(method, *args, &block)
        __force__.__send__(method, *args, &block)
      end
    end # class Promise

  end
end

module Kernel
  ##
  # Creates a new promise.
  #
  # @example Lazily evaluate an arithmetic operation
  #   x = promise { 3 + 3 }
  #
  # @yield       []
  #   A block to be lazily evaluated.
  # @yieldreturn [Object]
  #   The return value of the block will be the lazily evaluated value of the promise.
  # @return      [Promise]
  def promise(&block)
    AssortedCandy::Concurrency::Promise.new(&block)
  end
end


if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  z = promise{ 2 * 2 }
  check( z == 4 )

end
