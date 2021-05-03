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

module Accessor
  def self.included(base)
    base.extend ClassMethods
  end 

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym
        #Возмоэно потребуется own_values задать динамически, пока что разумная схема не работает, дебагер не помог
        define_method(name) { instance_variable_get(var_name); @own_values[name] = [] }
        define_method("#{name}=".to_sym) { |value| instance_variable_set(var_name, value);
        @own_values[name].append(value) }
        define_method("#{name}_history") { @own_values[name] }
      end
    end

    def strong_attr_accessor(name, klass)
      var_name = "@#{name}".to_sym
      define_method(name) { instance_variable_get(var_name) }
      define_method("#{name}=".to_sym) do |value|
        if value.class == klass 
          instance_variable_set(var_name, value)
        else
          raise 'Ошибка присвоения, тип аргумента не соответствует типу переменной'
        end
      end
    end
  end
end
#По сути, нужно сначала передать переменную, как передавали в прошлых методах(символом), но теперь они должны уже существовать
#Затем, нужно передать символом тип валидации, где будет условие типа если одно, то выполняется код для этого типа, и последний 
#Аргумент, который по умолчанию 0, будет передаваться для каких-то проверок. Вот такая вот дичь. Я в шоке 
module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end 

  module ClassMethods
    def validate(name, valiration_type, specifics = 0)
      valid_this = valiration_type.to_s
      if valid_this == 'presence'
        raise 'Значение атрибута не может быть nil!' if name.nil?
        raise 'Значение атрибута не может быть пустым!' if name == ''
      end
      if valid_this == 'format'
        form = specifics
        raise 'Значение атрибута не соответствует формату' if name !~ form
      end
      if valid_this == 'type'
        type = specifics
        raise 'Тип атрибута не соовтетствует заданному' if name != type 
      end
    end
  end
  #Проблема с вызовом вот этого валидейт :a, :hui
  module InstanceMethods
    def validate!
      self.class.validate
    end
  end
end

class Test
  include Accessor
  include Validation
  attr_accessor_with_history :a, :b, :c
  validate :a, :presence
  strong_attr_accessor :d, Integer
  def initialize
    #Возможно, потребуется подключать эту переменую в каждый класс динамически
    @own_values = {}
  end

end

test = Test.new
test.a
test.b
test.b = 7
test.c 
test.b = 99
test.c = 7
test.d
test.validate!








