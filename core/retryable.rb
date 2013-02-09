# Taken from https://github.com/subelsky/subelsky_power_tools/blob/master/lib/subelsky_power_tools/ext/kernel.rb

module AssortedCandy
  module Core

    module Retry
      def retryable(options = {})
        tries         = options.fetch(:tries, 1)
        exceptions    = options.fetch(:on, [StandardError])
        sleep_seconds = options.fetch(:sleep, 1)

        count = 0
        begin
          count += 1
          yield
        rescue *exceptions => e
          if count < tries
            Kernel.sleep(sleep_seconds)
            retry
          else
            raise e
          end
        end
      end
    end

  end
end

Kernel.send(:extend, AssortedCandy::Core::Retry)


# retryable(tryes: 5){ ...do failurable things... }
#

if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  check( Kernel.instance_methods.include?(:retryable) )

  retryable
end
