# Taken from https://gist.github.com/phluid61/5747216
# original http://alindeman.github.io/2013/06/10/porting-iterate-to-ruby.html

class Object
  def iter_for m
    obj = self
    Enumerator.new do |y|
      loop do
        y << obj
        obj = obj.send(m)
      end
    end
  end
end

class Method
  def to_iter
    obj = receiver
    Enumerator.new do |y|
      loop do
        y << obj
        obj = obj.send(name)
      end
    end
  end
end

if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  check( [0,1,2,3,4]  == 0.iter_for(:next).take(5) )
  check( 'abcdefghij' == 'a'.iter_for(:succ).take(10).join )
  check( [0,1,2,3,4]  == 0.method(:next).to_iter.take(5) )

  require 'date'
  p Date.new(2013, 1, 1).iter_for(:next_month).take(6)

end
