# Taken from https://github.com/bhuga/promising-future/blob/master/lib/future.rb

require './promise'

##
# A delayed-execution result, optimistically evaluated in a new thread.
#
# @example
#   x = future { sleep 5; 1 + 2 }
#   # do stuff...
#   y = x * 2     # => 6.  blocks unless 5 seconds has passed.
#
module AssortedCandy
  module Concurrency

    class Future < defined?(BasicObject) ? BasicObject : Object
      instance_methods.each { |m| undef_method m unless m =~ /^(__.*|object_id)$/ }

      ##
      # Creates a new future.
      #
      # @yield  [] The block to evaluate optimistically.
      # @see    Kernel#future
      def initialize(&block)
        @promise = ::AssortedCandy::Concurrency::Promise.new(&block)
        @thread  = ::Thread.new { @promise.__force__ }
      end

      ##
      # The value of the future's evaluation.  Blocks until result available.
      #
      # @return [Object]
      def __force__
        @thread.join if @thread
        @promise
      end
      alias_method :force, :__force__

      ##
      # Does this future support the given method?
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
    end # class Future

  end
end


module Kernel
  ##
  # Creates a new future.
  #
  # @example Evaluate an operation in another thread
  #   x = future { 3 + 3 }
  #
  # @yield       []
  #   A block to be optimistically evaluated in another thread.
  # @yieldreturn [Object]
  #   The return value of the block will be the evaluated value of the future.
  # @return      [Future]
  def future(&block)
    AssortedCandy::Concurrency::Future.new(&block)
  end
end



if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  z = future{ sleep(2); 2 * 2 }
  puts 'waiting for a 2 sec until long calculation finished...'
  x = future{ sleep(1); z + 38 }
  puts 'lazily start next operation...'
  check( z == 4 )
  check( x == 42 )

end
