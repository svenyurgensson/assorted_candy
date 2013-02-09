
# taken from http://rbjl.net/55-pass-multiple-blocks-to-methods-using-named-procs
#
module AssortedCandy
  module Core

    # Class for a proc that's got a name
    class NamedProc < Proc
      attr_reader :name

      def initialize(name)
        @name = name
        super()
      end

      # create one from a given proc/lambda object
      def self.create(name, block, lambda = false)
        name = name.to_sym
        # sorry for this ugly hack, is there a better way to lambdafy?
        block = Module.new.send(:define_method, name.to_sym, &block) if lambda

        new(name, &block)
      end

      # Proxy object to ease named proc initialization
      module Proxy
        Proc = BasicObject.new
        def Proc.method_missing(name, &block) NamedProc.create(name, block) end

        Lambda = BasicObject.new
        def Lambda.method_missing(name, &block) NamedProc.create(name, block, true) end
      end

      # Mixing in low level method "links"
      module Object
        private
        # create a proc with name if given
        def proc
          if block_given?
            super
          else
            NamedProc::Proxy::Proc
          end
        end

        # same for lambda
        def lambda
          if block_given?
            super
          else
            NamedProc::Proxy::Lambda
          end
        end
      end
    end # module NamedProc

  end
end

::Object.send(:include, AssortedCandy::Core::NamedProc::Object)


=begin
  Named Procs
    A named proc acts like a normal proc, but has got a name attribute.
    You can create it by calling a method with the desired name on +proc+:
=end


if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  a = proc.even?{ |e| e.even? }
  check( a.name == :even? )
  check( a[41] == false )
  check( a[42] == true )

  b = lambda.doubler{ |e| e * 2 }
  check( b.name == :doubler )
  check( b[21] == 42 )

end
