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

module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end 

  module ClassMethods
    attr_accessor :params_hash, :params
    def validate(name, v_type, specifics = 0)
      self.params_hash = {}
      self.params_hash = {['name']=>name,['types']=>v_type,['specials']=>specifics }
      self.params ||= []
      self.params.append(self.params_hash)
    end
  end

  module InstanceMethods
    def validate!
      self.class.params.each do |param|
        if param['types'] == :presence
          presence
        end
        if param['types'] == :format
          form
        end
        if param['types'] == :type
          type
        end
      end
    end
    
     def presence
      if @own_values[param['name']][0].nil?
        print 'Переменная, не прошедшая валидацию: '
        puts param['name']
        raise  'Значение атрибута не может быть nil!'
      end
      if @own_values[param['name']][0] == ''
        print 'Переменная, не прошедшая валидацию: '
        puts param['name']
        raise 'Значение атрибута не может быть пустым!' 
      end
    end

    def form
      if @own_values[param['name']][-1] !~ param['specials']
        print 'Переменная, не прошедшая валидацию: '
        puts param['name']
        raise 'Значение атрибута не соответствует формату'
      end
    end

    def type 
      if @own_values[param['name']][-1].class != param['specials']
        print 'Переменная, не прошедшая валидацию: '
        puts param['name']
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
  attr_accessor :own_values
  attr_accessor_with_history :a, :b, :c
  validate :a, :presence
  validate :b, :type, Integer
  strong_attr_accessor :d, Integer
  def initialize
    #Возможно, потребуется подключать эту переменую в каждый класс динамически можно как в методе validate, но зачем...
    @own_values = {}
  end
end





