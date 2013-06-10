# Taken from http://t-a-w.blogspot.com/2010/05/very-simple-parallelization-with-ruby.html

require 'thread'

def Exception.ignoring_exceptions
  begin
    yield
  rescue Exception => e
    STDERR.puts e.message
  end
end

module Enumerable

  def in_parallel
    map{ |x| Thread.new{ yield(x) } }.each(&:join)
  end

  def in_parallel_n(n)
    queue = Queue.new
    ts = (1..n).map do
      Thread.new do
        while x = queue.deq
          Exception.ignoring_exceptions{ yield(x[0]) }
        end
      end
    end
    each{ |x| queue << [x] }
    n.times{ queue << nil }
    ts.each(&:join)
  end
      
end



=begin

(1..1665).in_parallel_n(10) do |i|
  system "wget", "-q", "http://www.questionablecontent.net/comics/#{i}.png"
end

=end

if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  check( Enumerable.instance_methods.include?(:in_parallel) )
  check( Enumerable.instance_methods.include?(:in_parallel_n) )

end
