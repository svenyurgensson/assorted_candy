
# taken from http://rbjl.net/55-pass-multiple-blocks-to-methods-using-named-procs
#
require './named_proc'

module AssortedCandy
  module Core

    module MultiBlock
      # multiple block transformation method,
      # sorry for the method length and the code dup ;)
      def self.[](*proc_array)
        # Create hash representation, proc_array will still get used sometimes
        proc_hash = {}
        proc_array.each{ |proc|
          proc_hash[proc.name] = proc if proc.respond_to?(:name)
        }

        # Build yielder proc
        Proc.new{ |*proc_names_and_args|
          if proc_names_and_args.empty? # call all procs
            ret = proc_array.map(&:call)

            proc_array.size == 1 ? ret.first : ret
          else
            proc_names, *proc_args = *proc_names_and_args

            if proc_names.is_a? Hash # keys: proc_names, values: args
              proc_names.map{ |proc_name, proc_args|
                proc = proc_name.is_a?(Integer) ? proc_array[proc_name] : proc_hash[proc_name.to_sym]
                proc or raise LocalJumpError, "wrong block name given (#{proc_name})"

                [proc, Array(proc_args)]
              }.map{ |proc, proc_args|  proc.call(*proc_args) }
            else
              ret = Array(proc_names).map{ |proc_name|
                proc = proc_name.is_a?(Integer) ? proc_array[proc_name] : proc_hash[proc_name.to_sym]
                proc or raise LocalJumpError, "wrong block name given (#{proc_name})"

                [proc, Array(proc_args)]
              }.map{ |proc, proc_args| proc.call(*proc_args) }

              ret.size == 1 ? ret.first : ret
            end
          end
        }
      end

      # low level mixins
      module Object
        private
        # to_proc helper, see README
        def blocks; MultiBlock;  end
        # alias procs blocks
        # alias b blocks
      end

      # Bonus array mixin (if you want to)
      module Array
        # see README for an example
        def to_proc; ::MultiBlock[*self]; end
      end

    end # module MultiBlock

  end
end

::Object.send :include, AssortedCandy::Core::MultiBlock::Object
::Array.send :include,  AssortedCandy::Core::MultiBlock::Array

if __FILE__ == $0
  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end

  def ajax predicat
    yield predicat ? :success : :error
  end

  check(
    ajax(true, &blocks[ proc.success{ "Yeah!" },
                       proc.error{ "Error..." } ]) == "Yeah!"
        )

  check(
    ajax(false, &blocks[ proc.success{ "Yeah!" },
                       proc.error{ "Error..." } ]) == "Error..."
        )


end
