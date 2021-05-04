require_relative 'modules'
# class station contains name, list of trains, types of trains
class Station
  include InstanceCounter
  include Accessor
  include Validation
  attr_reader :name, :trains
  @@instances = []

  def self.all
    @@instances
  end

  def initialize(name)
    @name = name
    @trains = []
    @@instances.append(self)
    validate_st!
  end

  def accept_train(train_new)
    @trains.append(train_new)
    train_new.stop
  end

  def send_train(train_to_remove)
    @trains.delete(train_to_remove)
  end

  def freight_trains
    trains = []
    @trains.each do |train|
      if train.type == 'freight'
        trains.append(train.number)
      end
    end
  end

  def freight_trains_count
    freight_trains.length
  end

  def passenger_trains
    trains = []
    @trains.each do |train|
      if train.type == 'passenger'
        trains.append(train.number)
      end
    end
  end

  def passenger_trains_count
    passenger_trains.length
  end

  def valid?
    validate_st!
  rescue
    false
  end

  def validate_st!
    raise "Поле названия станции не может быть пустым!" if name == ''
    true
  end

  def show_trains(block)
    @trains.each { |train| block.call train}
  end
end
