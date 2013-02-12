
module AssortedCandy
  module Null

    class Unevaluated < ::BasicObject

      def ==(*);  false; end
      def to_f;   0.0;   end
      def to_i;   0;     end
      def to_s;   "";    end
      def *(*);   0;     end
      def +(*);   0;     end
      def -(*);   0;     end
      def /(*);   1;     end

      def coerce(_other)
        [self,_other]
      end

      def inspect
        "#<%s:0x%x>" % [self.class, object_id]
      end

      def method_missing(*, &_)
        self
      end

      def respond_to?(message, include_private=false)
        true
      end
    end # class Unevaluated

  end
end

UNEVAL_OBJ = AssortedCandy::Null::Unevaluated.new.freeze



if __FILE__ == $0

  the_entity = AssortedCandy::Null::Unevaluated.new

  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  check( (the_entity + 42) == 0 )
  check( (the_entity / 42) == 1 )

end
