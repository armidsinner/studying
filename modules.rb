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
      define_method('own_values'.to_sym) { instance_variable_get('@own_values'.to_sym)}
      define_method("own_values=".to_sym) {instance_variable_set('@own_values'.to_sym, {})}
      names.each do |name|
        var_name = "@#{name}".to_sym
        #Возмоэно потребуется own_values задать динамически, пока что разумная схема не работает, дебагер не помог
        define_method(name) { instance_variable_get(var_name);@own_values ||= {}; @own_values[name] = [] }
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

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end 

  module ClassMethods
    attr_accessor :params_hash, :params
    def validate(name, v_type, specifics = 0)
      self.params_hash = {}
      self.params_hash = {'name'=>name,'types'=>v_type,'specials'=>specifics }
      self.params ||= []
      self.params.append(self.params_hash)
    end
  end

  module InstanceMethods
    def validate!
     
      self.class.params.each do |param|
        send param['types'].to_sym, instance_variable_get("@#{param['name']}".to_sym), param['specials']
      end
    end

    def presence(value, specifics)
      if value.nil?
        raise  'Значение атрибута не может быть nil!'
      end
      if value == ''
        raise 'Значение атрибута не может быть пустым!' 
      end
    end

    def format(value, specifics)
      if value !~ specifics
        raise 'Значение атрибута не соответствует формату'
      end
    end

    def type(value, specifics)
      if value.class != specifics
        raise 'Тип атрибута не соответствует заданному' 
      end
    end
      
    def valid?
      validate!
    rescue
      false
    end
  end
end


class Test
  include Accessor
  include Validation
  attr_accessor_with_history :a, :b, :c
  validate :a, :presence
  validate :b, :format, /^([а-яa-z]|\d){3}-?([а-яa-z]|\d){2}$/i
  strong_attr_accessor :d, Integer
end
