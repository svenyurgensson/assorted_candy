# Taken from https://github.com/rubyworks/facets/blob/master/lib/standard/facets/ostruct/to_ostruct.rb

require 'ostruct'

class OpenStruct
  #
  def to_ostruct
    self
  end
end

class Hash
  # Turns a hash into a generic object using an OpenStruct.
  #
  #   o = {'a' => 1}.to_ostruct
  #   o.a  #=> 1
  #
  def to_ostruct
    OpenStruct.new(self)
  end

  # Like to_ostruct but recusively objectifies all hash elements as well.
  #
  #   o = {'a' => { 'b' => 1 }}.to_ostruct_recurse
  #   o.a.b  #=> 1
  #
  # The +exclude+ parameter is used internally to prevent infinite
  # recursion and is not intended to be utilized by the end-user.
  # But for more advance use, if there is a particular subhash you
  # would like to prevent from being converted to an OpoenStruct
  # then include it in the +exclude+ hash referencing itself. Eg.
  #
  #   h = { 'a' => { 'b' => 1 } }
  #   o = h.to_ostruct_recurse( { h['a'] => h['a'] } )
  #   o.a['b']  #=> 1
  #
  # CREDIT: Alison Rowland, Jamie Macey, Mat Schaffer
  def to_ostruct_recurse(exclude={})
    return exclude[self] if exclude.key?( self )
    o = exclude[self] = OpenStruct.new
    h = self.dup
    each_pair do |k,v|
      h[k] = v.to_ostruct_recurse( exclude ) if v.respond_to?(:to_ostruct_recurse)
    end
    _table = o.instance_variable_get :@table
    h.each_pair do |k, v|
      k = k.to_sym
      _table[k] = v
      o.send :new_ostruct_member, k
    end
    o
  end
end

class NilClass
  # Create an empty OpenStruct object.
  def to_ostruct
    OpenStruct.new
  end
end


if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  o = {'a' => { 'b' => 1 }}.to_ostruct_recurse
  check( o.a.b == 1 )

end
