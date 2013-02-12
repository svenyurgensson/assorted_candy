# Taken from https://github.com/hopsoft/footing/

module AssortedCandy
  module Core

    module Numeric

      # Returns a positive representation of the number.
      def positive
        abs
      end

      # Returns a negative representation of the number.
      def negative
        abs.flip_sign
      end

      # Flips the sign on the number making it either either positive or negative.
      def flip_sign
        self * -1
      end

      # Returns the percentage that this number is of the passed number.
      # @example
      #   8.percent_of(10) # => 80.0
      # @param [Numeric] number The number to calculate the percentage with
      def percent_of(number)
        percent = (self.to_f / number.to_f) * 100 if number > 0
        percent ||= 0.0
      end

      # Rounds the number to a certain number of decimal places.
      # @example
      #   1.784329.round_to(1) # => 1.8
      # @param [Numeric] decimal_places The number of decimal places to round to
      def round_to(decimal_places)
        (self * 10**decimal_places).round.to_f / 10**decimal_places
      end

    end # module Numeric

  end
end

::Numeric.send(:include, AssortedCandy::Core::Numeric)

if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  check( -2.positive == 2 )
  check( 2.negative == -2)
  check( 8.percent_of(10) == 80.0 )
  check( 1.786533.round_to(1) == 1.8 )

end
