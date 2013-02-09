# -*- encoding : utf-8 -*-

class ActiveRecord::Base

  def self.decorator_class
    klass = self
    while klass < ActiveRecord::Base
      begin
        decorator = "#{klass.name}Decorator".constantize
        return decorator
      rescue NameError
        klass = klass.superclass
      end
    end
    nil
  end

end
