
unless $LOAD_PATH.include?(path = File.dirname(File.expand_path(__FILE__)))
  $: << path
end

module AssortedCandy
  @known = Dir[File.join(File.dirname(__FILE__), 'assorted_candy/**/*.rb')]
  def self.[](*names)
    names.each do |name|
      if library = @known.detect{|lib| lib.end_with?(name.to_s+'.rb') }
        Kernel.require_relative(library)
      end
    end
  end
end

# Use: AssortedCandy[:hook, :null_object, :option]

## Uncomment requires you need

# require 'assorted_candy/businnes/rcodes'

# require 'assorted_candy/aop/hook'

# require 'assorted_candy/fpatterns/null_object'
# require 'assorted_candy/fpatterns/unevaluated'
# require 'assorted_candy/fpatterns/option'

# require 'assorted_candy/concurrency/in_parallel'
# require 'assorted_candy/concurrency/simple_future'
# require 'assorted_candy/concurrency/future'
# require 'assorted_candy/concurrency/promise'

# require 'assorted_candy/core/include'
# require 'assorted_candy/core/class2proc'
# require 'assorted_candy/core/array2proc'
# require 'assorted_candy/core/iter_for'
# require 'assorted_candy/core/let'
# require 'assorted_candy/core/multi_block'
# require 'assorted_candy/core/named_proc'
# require 'assorted_candy/core/subclasses'
# require 'assorted_candy/core/superclasses'
# require 'assorted_candy/core/tap_if'
# require 'assorted_candy/core/retryable'
# require 'assorted_candy/core/pretty_exception'

# require 'assorted_candy/ext/binarize_ostruct'
# require 'assorted_candy/ext/enum_ext'
# require 'assorted_candy/ext/hash_ext'
# require 'assorted_candy/ext/mnemo'
# require 'assorted_candy/ext/nested_ostruct'
# require 'assorted_candy/ext/sort_in_order'
# require 'assorted_candy/ext/to_hash_by'
# require 'assorted_candy/ext/to_ostruct'

# require 'assorted_candy/rails/decorative'
