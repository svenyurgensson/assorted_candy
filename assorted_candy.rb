
unless $LOAD_PATH.include?(path = File.dirname(File.expand_path(__FILE__)))
  $: << path
end

module AssortedCandy
end


## Uncomment requires you need

# require 'null_object/null_object'
# require 'null_object/unevaluated'

# require 'threads/in_parallel'
# require 'threads/simple_future'

# require 'core/include'
# require 'core/let'
# require 'core/multi_block'
# require 'core/named_proc'
# require 'core/subclasses'
# require 'core/tap_if'
# require 'core/retryable'
# require 'core/pretty_exception'

# require 'ext/to_ostruct'
# require 'ext/hash_ext'
# require 'ext/to_hash_by'
# require 'ext/binarize_ostruct'
# require 'ext/nested_ostruct'
