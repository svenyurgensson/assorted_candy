
class Array
  def extract_options!
    if last.is_a?(Hash)
      pop
    else
      {}
    end
  end unless method_defined?(:extract_options!)

end


if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  z = [1, 2, {hello: :kitty}]
  zz = [1,2,3]
  check( z.extract_options! == {hello: :kitty} )
  check( zz.extract_options! == {} )

end
