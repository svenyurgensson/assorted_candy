#

module AssortedCandy
  module Ext

    module DeepDelegate
      # Same as delegate, but will try to call :to several times on itself while reaches something,
      # which responds to the given method. I.e.:
      #
      #   deep_delegate :foo, to: :bar
      #
      #   self.foo # => it may call self.bar.bar.bar.foo, if only self.bar.bar.bar responds to :foo
      #
      def deep_delegate(*methods)
        delegate_builder(*methods) do |prefix, method, to, allow_nil|
          method_name = "#{prefix}#{method}"
          module_eval(<<-EOS, "(__DELEGATION__)", 1)
            def #{method_name}(*args, &block)
              to = #{to}
              while to && !to.respond_to?(#{method.inspect})
                to = to.respond_to?(#{to.inspect}) ? to.#{to} : nil
              end
              to.__send__(#{method.inspect}, *args, &block)
            end
          EOS
        end
      end

      def delegate_builder(*methods)
        options = methods.pop
        unless options.is_a?(Hash) && to = options[:to]
          raise ArgumentError, "Delegation needs a target. Supply an options hash with a :to key as the last argument (e.g. delegate :hello, :to => :greeter)."
        end

        if options[:prefix] == true && options[:to].to_s =~ /^[^a-z_]/
          raise ArgumentError, "Can only automatically set the delegation prefix when delegating to a method."
        end

        prefix = options[:prefix] && "#{options[:prefix] == true ? to : options[:prefix]}_"

        allow_nil = options[:allow_nil] && "#{to} && "

        methods.each do |method|
          yield(prefix, method, to, allow_nil)
        end
      end
    end

  end
end

::Module.send(:include, AssortedCandy::Ext::DeepDelegate)

if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  module Mod
    def self.hello
      'Hello, World!'
    end
  end

  class A
    deep_delegate :baz, to: 'Mod.hello'
  end

  z = A.new
  p z.baz


end
