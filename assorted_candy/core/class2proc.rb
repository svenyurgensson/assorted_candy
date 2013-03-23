
class Class
  def to_proc
    proc(&method(:new))
  end
end

if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  require 'ostruct'
  class Person < OpenStruct
  end

  res = [{:name => 'Dan'}, {:name => 'Josh'}].map(&Person)
  check(res[0].name = 'Dan')
  check(res[1].name = 'Josh')
end
