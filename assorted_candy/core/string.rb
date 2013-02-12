# encoding: utf-8
# Taken from https://github.com/hopsoft/footing/

module AssortedCandy
  module Core

    module String

      # Generates a random string.
      #
      # @example
      #   ::String.random_key(100, :reject => ["1", "I", "l", "0", "O"])
      #
      # @param [Integer] length The length of the key to generate. Defaults to 12.
      # @param [Hash] opts
      # @option opts [Array] :reject A list of characters to omit from the key.
      # @option opts [Boolean] :upcase Indicates that only use uppercase characters should be used.
      # @return [String]
      def random(length=12, opts={})
        @chars ||= [(0..9).to_a, ('a'..'z').to_a, ('A'..'Z').to_a].flatten.map { |c| c.to_s }
        chars = @chars.reject do |c|
          c =~ /[a-z]/ if opts[:upcase]
        end
        opts[:reject] ||= []
        opts[:reject] = opts[:reject].map { |c| c.to_s }
        (1..length).map{ |i| (chars - opts[:reject]).sample }.join
      end

      # Escapes a series of chars in the current string.
      # NOTE: A new string is returned.
      def escape(*chars)
        gsub(/(?<!\\)(#{chars.join("|")})/) do |char|
          "\\" + char
        end
      end

      # Converts a word with underscores into a sentance with a capitalized first word.
      def humanize
        self.downcase.gsub(/_/, " ").capitalize
      end

      # Similar to humanize but it capitalizes each word
      def titleize
        self.gsub(/\s/, "_").split('_').map(&:capitalize).join(' ')
      end
      alias :titlecase :titleize


      def classify
        self.gsub(/\s/, "_").titleize.gsub(/\W/, "")
      end

      # Indicates if this string represents a number.
      def numeric?
        !!(self =~ /\A[0-9]+\.*[0-9]*\z/)
      end

      # Indicates if this string represents a boolean value.
      def boolean?
        !!(self =~ /\A(true|false)\z/i)
      end

      # Casts this string to another datatype.
      # Supported datatypes:
      # * Integer
      # * Float
      # * Boolean
      def cast
        return to_f if numeric? && index(".")
        return to_i if numeric?
        if boolean?
          return true if self =~ /\Atrue\z/i
          return false if self =~ /\Afalse\z/i
        end
        self
      end

    end

    def slugify
      str = self.dup
      str.gsub!(/\A\s+|\s+\z/, '')
      str.downcase!

      from = "àáäâèéëêìíïîòóöôùúüûñç·/_,:;."
      to   = "aaaaeeeeiiiioooouuuunc-------"

      idx = 0
      from.each_char do |c|
        str.gsub!(c, to[idx])
        idx += 1
      end

      str.gsub!(/[^a-z0-9 -]/, '')
      str.gsub!(/\s+/, '-')
      str.gsub!(/\-+/, '-')

      str
    end


  end
end

::String.send(:include, AssortedCandy::Core::String)


if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  check( "true".boolean? == true )
  check( "22".numeric? == true )
  check( "H2".numeric? == false )

end
