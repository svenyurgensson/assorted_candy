
require 'ostruct'

# Extend OpenStruct to support nested structures
class NestedOpenStruct < OpenStruct
  def [](key)
    @table[key.to_sym]
  end
  def initialize(hash = nil)
    @table = {}
    if hash
      for k, v in hash
        if v.instance_of?(Hash)
          @table[k.to_sym] = NestedOpenStruct.new(v)
        else
          @table[k.to_sym] =  v
        end
        new_ostruct_member(k)
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

  z = NestedOpenStruct.new( {a: {b: {c: 1}}} )
  check( z.a.b.c == 1 )

end
