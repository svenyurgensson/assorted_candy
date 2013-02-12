# Taken from http://endofline.wordpress.com/2011/01/18/ruby-standard-library-delegator/

require 'delegate'

class SimpleFuture < SimpleDelegator
  def initialize(&block)
    @_thread = Thread.start(&block)
  end

  def __getobj__
    __setobj__(@_thread.value) if @_thread.alive?
    super
  end

  def ready?
    @_thread.stop?
  end

end

=begin

  require 'net/http'
  # These will each execute immediately
  google = SimpleFuture.new{ Net::HTTP.get_response(URI('http://www.google.com')).body  }
  yahoo  = SimpleFuture.new{ Net::HTTP.get_response(URI('http://www.yahoo.com')).body  }

  # These will block until their requests have loaded
  puts google
  puts yahoo

=end

if __FILE__ == $0
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  f = SimpleFuture.new { print "Start...\n"; sleep 1; "Finished..." }
  check( f.ready? == false )
  check( f == "Finished..." ) # actually waiting for a result
  check( f.ready? == true )
end
