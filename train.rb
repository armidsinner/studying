require_relative 'modules'

# class train contains number, type, amount of vagons and route
class Train
  include InstanceCounter
  include SetBrand
  include Accessor
  include Validation
  attr_reader :number, :own_route, :speed, :vagons, :type
  @@instances = []

  def self.all
    @@instances
  end

  def self.find(number)
    @@instances.find { |train| train.number == number.to_s }
  end


  def initialize(number)
    @own_values = {}
    @number = number
    @speed = 0
    @vagons = []
    @type = type
    @@instances.append(self)
    register_instance
    @own_values = {}
  end

  def gain_speed(gain)
    @speed += gain
  end

  def stop
    @speed = 0
  end

  def add_vagon(vagon)
    @vagons.append(vagon) if @speed.zero? && vagon.type == @type
  end

  def remove_vagon
    @vagons.pop if @speed.zero?
  end

  def new_route(own_route)
    @own_route = own_route
    @station_index = 0
    current_station.accept_train(self)
  end

  def move_train_next
    next_station.accept_train(self)
    current_station.send_train(self)
    @station_index += 1
  end

  def move_train_back
    previous_station.accept_train(self)
    current_station.send_train(self)
    @station_index -= 1
  end

  def current_station
    @own_route.list_of_stations[@station_index]
  end

  def previous_station
    unless @station_index == 0
      @own_route.list_of_stations[@station_index - 1]
    end
  end

  def next_station
    unless @station_index == @own_route.list_of_stations.length
      @own_route.list_of_stations[@station_index + 1]
    end
  end

  def show_vagons(block)
    @vagons.each { |vagon| block.call vagon}
  end
end
