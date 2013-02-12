
module AssortedCandy
  module Core

    module Subclasses
      # return a list of the subclasses of a class
      def subclasses(direct = false)
        classes = []
        if direct
          ObjectSpace.each_object(Class) do |c|
            next unless c.superclass == self
            classes << c
          end
        else
          ObjectSpace.each_object(Class) do |c|
            next unless c.ancestors.include?(self) and (c != self)
            classes << c
          end
        end
        classes
      end
    end # module Subclasses

  end
end

Object.send(:include, AssortedCandy::Core::Subclasses)




if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  check(
        Enumerable.subclasses ==
        [Enumerator::Generator, Enumerator, Struct::Tms, Dir, File, ARGF.class, IO, Range, Struct, Hash, Array]
        )

end
