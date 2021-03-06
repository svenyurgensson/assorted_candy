# Taken from https://github.com/chenfisher/hook_me_up

module AssortedCandy
  module Aop
    module Hook

      module ClassMethods
        def hook(*args)
          hooks = args.last.is_a?(::Hash) ? args.pop : {}

          args.flatten.each do |method|
            original_method = self.instance_method(method)

            self.send(:define_method, method) do |*a|
              options = a.last
              if options.is_a?(::Hash) && options[:no_hook] == true && a.pop
                result = original_method.bind(self).call(*a)
              elsif options.is_a?(::Hash) && options[:no_before_hook] == true && a.pop
                result = original_method.bind(self).call(*a)
                if hooks[:after]
                  if hooks[:after].is_a? Proc
                    hooks[:after].call(self, *a, result)
                  else
                    self.send(hooks[:after], *a, result)
                  end
                end
              elsif options.is_a?(::Hash) && options[:no_after_hook] == true && a.pop
                if hooks[:before]
                  if hooks[:before].is_a? Proc
                    hooks[:before].call(self, *a)
                  else
                    self.send(hooks[:before], *a)
                  end
                end

                result = original_method.bind(self).call(*a)
              else
                if hooks[:before]
                  if hooks[:before].is_a? Proc
                    hooks[:before].call(self, *a)
                  else
                    self.send(hooks[:before], *a)
                  end
                end

                result = original_method.bind(self).call(*a)

                if hooks[:after]
                  if hooks[:after].is_a? Proc
                    hooks[:after].call(self, *a, result)
                  else
                    self.send(hooks[:after], *a, result)
                  end
                end
              end

              result
            end
          end
        end
      end

      def self.included(receiver)
        receiver.extend  ClassMethods
      end

    end
  end
end

if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  class SomeClass
    include AssortedCandy::Aop::Hook
    attr_reader :result
    def initialize
      @result = []
    end

    def some_method
      @result << "Hello!"
    end

    private
    def before_hook
      @result << "--> before hook"
    end

    def after_hook(*)
      @result << "--> afer hook"
    end

    hook [:some_method], before: :before_hook, after: :after_hook
  end

  z = SomeClass.new
  z.some_method
  check(z.result == ["--> before hook", "Hello!", "--> afer hook"])

  z = SomeClass.new
  z.some_method({no_before_hook: true})
  check(z.result == ["Hello!", "--> afer hook"])

  z = SomeClass.new
  z.some_method({no_after_hook: true})
  check(z.result == ["--> before hook", "Hello!"])


end
