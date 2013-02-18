
module Enumerable
  # Taken from http://uberpwn.wordpress.com/2012/02/29/extend-ruby-enumerables-with-an-eachn-processor/
  def eachn(&block)
    n = block.arity
    each_slice(n) {|i| block.call(*i)}
  end unless instance_methods.include? 'eachn'

  def map_hash
    Hash[*self.inject([]) { |arr, a| arr += yield(a) }]
  end unless instance_methods.include? 'map_hash'
end

if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  # eachn
  a = (1..10).to_a
  a.eachn {|x,y,z| p [x,y,z]}


  # map_hash
  z = [1,2,3].map_hash { |x| [x, x*2] }
  check( z == {1=>2, 2=>4, 3=>6} )

end
