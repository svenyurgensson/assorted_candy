# Taken from http://kresimirbojcic.com/2012/01/28/let-it-be.html

class Object
  alias :Let :define_singleton_method
end


if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end


  Let(:stupid?){ @pretty ? "NO" : "YES" }
  check( stupid? == 'YES')

  @pretty = true
  check( stupid? == 'NO')

end
