
class Hash
  # Returns the hash with entries removed
  def except(*keys)
    self.reject { |k,v| keys.include? k.to_sym }
  end unless instance_methods.include? 'except'

  # Returns a new hash with only the entries specified
  def only(*keys)
    self.dup.reject { |k,v| !keys.include? k.to_sym }
  end unless instance_methods.include? 'only'

  # Taken from https://github.com/hopsoft/footing
  # Recursively forces all String values to the specified encoding.
  # @param [] encoding The encoding to use.
  # @yield [value] Yields the value after the encoding has been applied.
  def force_encoding!(encoding, &block)
    each do |key, value|
      case value
        when String
          # force encoding then strip all non ascii chars
          if block_given?
            self[key] = yield(value.force_encoding(encoding))
          else
            self[key] = value.force_encoding(encoding)
          end
        when Hash then value.force_encoding!(encoding, &block)
      end
    end
  end unless instance_methods.include? 'force_encoding!'

  def symbolize_keys_deep!(h=self)
    h.keys.each do |k|
      ks    = k.respond_to?(:to_sym) ? k.to_sym : k
      h[ks] = h.delete k # Preserve order even when k == ks
      h.symbolize_keys_deep! h[ks] if h[ks].kind_of? Hash
    end
    self
  end unless instance_methods.include? 'sumbolize_keys_deep!'


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

  target = { 'a' => 'b', 'c' => { 'd' => { 'e' => 'f' }, 'g' => 'h' }, ['i'] => 'j' }
  result = { :a => 'b', :c => { :d => { :e => 'f' }, :g => 'h' }, ['i'] => 'j' }

  check( target.symbolize_keys_deep! == result )

end
