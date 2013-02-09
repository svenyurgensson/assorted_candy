# Taken from https://github.com/rubyworks/facets/blob/master/lib/core/facets/exception/detail.rb

module AssortedCandy
  module Core

    module PrettyException

      # Pretty string output of exception/error
      # object useful for helpful debug messages.
      #
      # Input:
      # The Exception/StandardError object
      #
      # Output:
      # The pretty printed string
      #
      # CREDIT: George Moschovitis

      def detail
        return %{#{self.class.name}: #{message}\n#{backtrace.join("\n  ")}\n  LOGGED FROM: #{caller[0]}}
      end
    end # module PrettyException

  end
end

Exception.send(:include, AssortedCandy::Core::PrettyException)


if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  check( Exception.instance_methods.include?(:detail) )

  begin
    z = 2/0
  rescue => e
    puts e.detail
  end
end
