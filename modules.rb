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

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end 

  module ClassMethods
    def instances
      self.all.count
    end
  end

  module InstanceMethods

    def register_instance
      self.class.instances
    end
  end
end

