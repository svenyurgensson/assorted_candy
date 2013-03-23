
class Array
  def to_proc
    lambda { |target| target.send(*self) }
  end
end

if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  res = %w(kung ruby bar).map { |e| e + "-fu" }

  check( res[0] == 'kung-fu' )
  check( res[1] == 'ruby-fu' )
  check( res[2] == 'bar-fu' )
end
