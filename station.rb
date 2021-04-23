require_relative 'modules'
# class station contains name, list of trains, types of trains
class Station
  include InstanceCounter
  attr_reader :name, :trains

  @@instances = []

  def Station.all
    @@instances
  end

  def initialize(name)
    @name = name
    @trains = []
    @@instances.append(self)
  end
# Методы используются не только внутри класса, следовательно, они public
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
end


