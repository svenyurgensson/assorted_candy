
module AssortedCandy
  module Core
    module Include

      # Taken from https://gist.github.com/avdi/4545113#file-selective_method_import-rb
      # Generate a module which imports a given subset of module methods
      # into the including module or class.
      def Methods(source_module, *method_names)
        all_methods = source_module.instance_methods +
          source_module.private_instance_methods
        unwanted_methods = all_methods - method_names
        import_module = source_module.clone
        import_module.module_eval do
          define_singleton_method(:to_s) do
            "ImportedMethods(#{source_module}: #{method_names.join(', ')})"
          end
          private(*method_names)
          remove_method(*unwanted_methods)
        end
        import_module
      end

      # In case you're wondering: no, it doesn't work to include the source
      # module and then call undef_method on unwanted methods. Well, it
      # works; but it *hides* any methods by the same name further up the
      # ancestor chain. This pretty much defeats the purpose of selective
      # import, since one reason for selective import is to keep a module
      # from stomping on methods from earlier in the ancestor chain.

      # Generate a module which imports a given subset of functions into the
      # including module or class. These are "functions" because they don't
      # execute in the context of self; they execute in the context of an
      # anonymous object. In other words, the imported functions are
      # forwarded.
      def Functions(source_module, *method_names)
        all_methods = source_module.instance_methods +
          source_module.private_instance_methods
        unwanted_methods = all_methods - method_names
        object = Object.new.extend(source_module)
        Module.new do
          define_singleton_method(:to_s) do
            "ImportedFunctions(#{source_module}: #{method_names.join(', ')})"
          end

          method_names.each do |name|
            define_method(name) do |*args, &block|
              object.send(name, *args, &block)
            end
          end
          private(*method_names)
        end
      end

    end # module Include
  end
end

Class.send(:include, AssortedCandy::Core::Include)






if __FILE__ == $0

  User = Struct.new(:name)

  module Users
    def merge(user1, user2)
      names = user1.name.split.zip(user2.name.split).flatten
      User.new(names.join(" "))
    end

    def fight(user1, user2)
      puts "#{[user1, user2].sample.name} wins"
    end

    def who_am_i
      self
    end
  end

  module HippyDippy
    def fight
      "Make love, not war!"
    end
  end

  class ImportsMethods
    include HippyDippy
    include Methods(Users, :merge, :who_am_i)

    public :who_am_i

    def do_some_stuff
      user1 = User.new("Zap Rowsdower")
      user2 = User.new("Space Chief")
      merge(user1, user2).name
    end
  end

  class ImportsFunctions
    include Functions(Users, :merge, :who_am_i)

    public :who_am_i

    def do_some_stuff
      user1 = User.new("Zap Rowsdower")
      user2 = User.new("Space Chief")
      merge(user1, user2).name
    end
  end

  # Test
  def check predicat
    line = 'line' + caller()[0][/:\d+:/]
    puts predicat ? "#{line} proved" : "#{line} not proven"
  end


  p ImportsMethods.included_modules
  # => [ImportedMethods(Users: merge, who_am_i),
  #     HippyDippy,
  #     Kernel]

  p ImportsFunctions.included_modules
  # => [ImportedFunctions(Users: merge, who_am_i), Kernel]

  obj1 = ImportsMethods.new
  obj2 = ImportsFunctions.new

  check( obj1.public_methods.include?(:merge) == false ) # => false
  check( obj1.private_methods.include?(:merge) == true ) # => true
  check( obj1.do_some_stuff == "Zap Space Rowsdower Chief" ) # => "Zap Space Rowsdower Chief"
  check( obj2.do_some_stuff == "Zap Space Rowsdower Chief" ) # => "Zap Space Rowsdower Chief"
  # Non-imported methods are left alone

  check( obj1.fight == "Make love, not war!" )

  # illustrate the difference between importing functions and methods:
  obj1.who_am_i                   # => #<ImportsMethods:0x000000009e9260>
  obj2.who_am_i                   # => #<Object:0x00000000b24e18>

  module Users
    def merge(user1, user2)
      # switcheroo!
      names = user2.name.split.zip(user1.name.split).flatten
      User.new(names.join(" "))
    end
  end

  # Unfortunately, changes to the original source module don't take
  # effect on imported methods because of the module cloning
  check( obj1.do_some_stuff ==  "Zap Space Rowsdower Chief" )


  # Imported functions DO pick up on changes to the source module
  check( obj2.do_some_stuff == "Space Zap Chief Rowsdower" )

end
