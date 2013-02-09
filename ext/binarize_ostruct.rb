
require 'ostruct'

# Just dirty hack to add support to easy get predicat from ostruct member value
# if we have ostruct.member
# so we have ostruct.member?
# it siple mapped from current member value with predicat's defaults

class OpenStruct
  def new_ostruct_member(orig_name)
    name = orig_name.to_sym
    predicat = "#{orig_name}?".to_sym
    unless self.respond_to?(name)
      class << self; self; end.class_eval do
        define_method(name) { @table[name] }
        define_method("#{name}=") { |x| modifiable[name] = x }
        define_method(predicat) do
          ! ['false', 'FALSE', nil, 'nil', '0', 0, false, 'NO', 'no'].include?(@table[name])
        end
      end
    end
    name
  end
end


if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  z = OpenStruct.new
  z.binary = 'false'
  check( z.binary? == false )
  z.binary = 'just a string'
  check( z.binary? == true )

  z.binary = '0'
  check( z.binary? == false )

end
