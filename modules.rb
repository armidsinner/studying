module SetBrand
  attr_accessor :brand
end

module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :counter
    def instances
      # Минус один, потому что иначе при вызове метода на классе будет прибавлен еще один элемент
      @counter = -1 if @counter.nil?
      @counter += 1
    end
  end

  module InstanceMethods
    # Метод, увеличивающий счетчик количества экземпляров, который можно вызвать только на экземпляре класса, в отличии от от instances
    # который можно вызвать на классе
    def register_instance
      self.class.instances
    end
  end
end
