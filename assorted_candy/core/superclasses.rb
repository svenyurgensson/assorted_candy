
module AssortedCandy
  module Core

    module Superclasses
      # Internal: Find all superclasses of the current class. You can limit the top
      # klass by the argument, and also include the current class into the
      # resulting array.
      #
      # top_class -    the most top superclass (Class) until we should search. Will
      #                be latest element in the resulting array (default: nil).
      # include_self - the Boolean value, specify if you want to include self class
      #                to the resuting array (as the first element)
      #                (default: false).
      #
      # Examples
      #
      #   Fixnum.superclasses # => [Integer, Numeric, Object, BasicObject]
      #   Fixnum.superclasses(Numeric) # => [Integer, Numeric]
      #   Fixnum.superclasses(Numeric, true) # => [Fixnum, Integer, Numeric]
      #
      # Returns Array of Class objects.
      def superclasses(top_class = nil, include_self = false)
        superclasses = []
        klass = self
        superclasses << klass if include_self
        while klass.superclass && klass != top_class
          superclasses << klass.superclass
          klass = klass.superclass
        end
        superclasses
      end
    end # module Superclasses

  end
end

Object.send(:include, AssortedCandy::Core::Superclasses)



if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  check( Fixnum.superclasses == [Integer, Numeric, Object, BasicObject] )
  check( Fixnum.superclasses(Numeric) == [Integer, Numeric] )
  check( Fixnum.superclasses(Numeric, true) == [Fixnum, Integer, Numeric] )

end
