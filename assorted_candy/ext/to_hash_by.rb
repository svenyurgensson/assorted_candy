
module AssortedCandy
  module Ext

    module ToHashBy
      def to_hash_by(&block)
        reduce({}) do |hash, element|
          hash[block.call(element)] = element
          hash
        end
      end
    end # module ToHashBy

  end
end

::Array.send(:include, AssortedCandy::Ext::ToHashBy)

if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  z = [1, 2, 3, 4, 5]
  check( z.to_hash_by{ |x| x * 2} == { 2=>1, 4=>2, 6=>3, 8=>4, 10=>5} )

end
