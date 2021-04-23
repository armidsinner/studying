module SetBrand

  def set(name)
    self.brand = name
  end

  def get_brand
    self.brand
  end 

  protected

  attr_accessor :brand
end
'
module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end 
  
  module ClassMethods
    def instances
      self.all.count
    end
  end'
# Сука снизу не работает на экземплярах. Пофиксить!!!!
  'module InstanceMethods
    
    def register_instance
      @counter += 1
    end
    def get_counter
      @counter
    end 

    protected

    attr_accessor :counter
  end
end'