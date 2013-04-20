# taken from https://github.com/rares/option
# http://robares.com/2012/09/16/ruby-port-of-scala-option/

class OptionClass

  def or_nil
  end

  def ==(that)
    case that
      when OptionClass then or_nil == that.or_nil
      else or_nil == that
    end
  end


  private

  def assert_option(result)
    case result
      when OptionClass then return result
      else raise TypeError, "Must be an Option"
    end
  end
end

class SomeClass < OptionClass

  def initialize(value)
    @value = value
  end

  def to_a
    [get]
  end

  def get
    @value
  end

  def get_or_else(&blk)
    get
  end

  def each(&blk)
    blk.call(get)

    nil
  end

  def ~(*funcs)
    return self unless funcs.length > 0
    Option(funcs.shift.to_proc.call(get)).~(*funcs)
  end

  def or_nil
    get
  end

  def present?
    true
  end

  def empty?
    false
  end

  def map(&blk)
    self.class.new(blk.call(get))
  end

  def flat_map(&blk)
    assert_option(blk.call(get))
  end

  def fold(if_empty, &blk)
    blk.call(get)
  end

  def exists?(&blk)
    !! blk.call(get)
  end

  def include?(value)
    get == value
  end

  def filter(&blk)
    exists?(&blk) ? self : None
  end

  def inside(&blk)
    blk.call(get)
    self
  end

  def or_else(&blk)
    self
  end

  def flatten
    case get
      when OptionClass then get.flatten
      else self
    end
  end
end

class NoneClass < OptionClass

  def dup
    raise TypeError, "can't dup NoneClass"
  end

  def clone
    raise TypeError, "can't clone NoneClass"
  end

  def to_a
    []
  end

  def get
    raise IndexError, "None.get"
  end

  def get_or_else(&blk)
    blk.call
  end

  def each(&blk)
    nil
  end

  def ~(*funcs)
    self
  end

  def or_nil
    nil
  end

  def present?
    false
  end

  def empty?
    true
  end

  def map(&blk)
    flat_map(&blk)
  end

  def flat_map(&blk)
    self
  end

  def fold(if_empty, &blk)
    if_empty.call
  end

  def exists?(&blk)
    false
  end

  def include?(value)
    false
  end

  def filter(&blk)
    self
  end

  def inside(&blk)
    self
  end

  def or_else(&blk)
    assert_option(blk.call)
  end

  def flatten
    self
  end
end

module Kernel

  None = NoneClass.new
  Some = SomeClass

  def Some(value)
    SomeClass.new(value)
  end

  def Option(value)
    value.nil? ? None : Some(value)
  end

end



if __FILE__ == $0

  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  foo = Option("bar")
  check( foo.get == 'bar' )
  check( None.get_or_else { "default" } == 'default' )
  check( foo.map{ |v| v.upcase }.get == 'BAR' )
  check( foo.map { |v| v * 2 }.map { |v| v.upcase }.get_or_else { "missing" } == 'BARBAR')
  check( None.fold(-> { "missing" }) { |v| v.upcase } == 'missing' )
  check( Option(" 1 ").~(:strip, :to_i, :next).get == 2)
  check( Option(nil).~(:strip, :to_i, :next).get_or_else { 'else' } == 'else')

  p None
  p Some

end
