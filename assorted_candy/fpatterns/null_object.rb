
module AssortedCandy
  module Null

    class NullObject < ::BasicObject

      def to_a;   [];   end
      def to_ary; [];   end
      def to_s;   "";   end
      def to_f;   0.0;  end
      def to_i;   0;    end
      def nil?;   true; end
      def present?; false; end
      def empty?; true; end
      def !;      true; end
      def tap;    self; end

      def inspect
        "#<%s:0x%x>" % [self.class, object_id]
      end

      def method_missing(*, &_)
        self
      end

      def respond_to?(message, include_private=false)
        true
      end

    end # class NullObject

  end
end

NULL_OBJ = AssortedCandy::Null::NullObject.new.freeze

if __FILE__ == $0

  NullUser = Class.new(AssortedCandy::Null::NullObject) do
    def name;  "No name";  end
    def phone; "No phone"; end
  end

  no_user = NullUser.new

  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  check(no_user.bar.baz == no_user)
  check(no_user.name == 'No name')
  check(no_user.to_s == '')

  check(no_user.foo(42, 'bar'){ 'block' } == no_user)

  check( !!no_user == false )

end
