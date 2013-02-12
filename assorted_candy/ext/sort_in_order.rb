#

module AssortedCandy
  module Ext

    module SortInOrder
      # Sort according to given order. The order is actually an array of methods, and if that method
      # returns true, then that specific element should go to that place. Example:
      #
      #   Book.all.sort_in_order([:softcover?, :hardcover?, :dust_jacket?])
      #
      # It will return the array of products, where softcover books will go first, then
      # there will be hardcover books, and at the end - dust jacket books.
      #
      # It also can be sorted by values of some field. In this case, you should provide the values
      # of the field as the first argument, and the field name as the second argument. Example:
      #
      #   Occasion.all.sort_in_order(%w{Winter Spring Autumn}, :name)
      #
      def sort_in_order(order, by_field = nil)
        return self unless order
        sort_by do |object|
          index = if by_field
            object.respond_to?(by_field) && order.index(object.send(by_field))
          else
            matching_elements = order.select { |method| object.respond_to?(method) && object.send(method) }
            matching_elements.map { |element| order.index(element) }.min
          end
          index || length
        end
      end
    end # module SortInOrder

  end
end

::Array.send(:include, AssortedCandy::Ext::SortInOrder)

if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  class Occasion < Struct.new(:name)
  end

  x   = %w(Autumn Spring Winter Spring Summer).map{|x| Occasion.new(x)}
  res = x.sort_in_order(%w(Summer Winter Spring Autumn), :name).map(&:name)
  check( res == ["Summer", "Winter", "Spring", "Spring", "Autumn"] )

end
