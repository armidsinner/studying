module SetBrand
  attr_accessor :brand
end

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_accessor :counter

    def instances
      if self.counter.nil?
        self.counter = 0
      end
      self.counter
    end
  end

  module InstanceMethods
    def register_instance
      self.class.counter ||= 0
      self.class.counter += 1
    end
  end
end
