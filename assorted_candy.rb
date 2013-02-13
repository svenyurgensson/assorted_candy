
unless $LOAD_PATH.include?(path = File.dirname(File.expand_path(__FILE__)))
  $: << path
end

module AssortedCandy
end


## Uncomment requires you need

# require 'assorted_candy/businnes/rcodes'

# require 'assorted_candy/null/null_object'
# require 'assorted_candy/null/unevaluated'

# require 'assorted_candy/concurrency/in_parallel'
# require 'assorted_candy/concurrency/simple_future'
# require 'assorted_candy/concurrency/future'
# require 'assorted_candy/concurrency/promise'

# require 'assorted_candy/core/include'
# require 'assorted_candy/core/let'
# require 'assorted_candy/core/multi_block'
# require 'assorted_candy/core/named_proc'
# require 'assorted_candy/core/subclasses'
# require 'assorted_candy/core/superclasses'
# require 'assorted_candy/core/tap_if'
# require 'assorted_candy/core/retryable'
# require 'assorted_candy/core/pretty_exception'

# require 'assorted_candy/ext/to_ostruct'
# require 'assorted_candy/ext/hash_ext'
# require 'assorted_candy/ext/to_hash_by'
# require 'assorted_candy/ext/binarize_ostruct'
# require 'assorted_candy/ext/nested_ostruct'
# require 'assorted_candy/ext/sort_in_order'

# require 'assorted_candy/rails/decorative'
