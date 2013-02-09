
class Hash
  # Returns the hash with entries removed
  def except(*keys)
    self.reject { |k,v| keys.include? k.to_sym }
  end unless instance_methods.include? 'except'

  # Returns a new hash with only the entries specified
  def only(*keys)
    self.dup.reject { |k,v| !keys.include? k.to_sym }
  end unless instance_methods.include? 'only'
end


if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  check( { a: 1, b: 2, c: 3}.except(:a) == { b: 2, c: 3 } )
  check( { a: 1, b: 2, c: 3}.except(:a, :c) == { b: 2 } )

  check( { a: 1, b: 2, c: 3}.only(:a) == { a: 1 } )
  check( { a: 1, b: 2, c: 3}.only(:a, :b) == { a: 1, b: 2 } )

end
