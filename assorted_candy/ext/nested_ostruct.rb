
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

  def as_json
    marshal_dump.as_json
  end

  def to_json
    marshal_dump.to_json
  end

  def to_h
    marshal_dump
  end

  def to_s
    marshal_dump.to_s
  end

  def inspect
    to_s
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

  p z.to_h
end
