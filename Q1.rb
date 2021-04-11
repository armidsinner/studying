# class station contains name, list of trains, types of trains
class Station
  attr_reader :name, :trains, :freight_count, :passenger_count
  def initialize(name)
    @name = name
    @trains = []
    @freight_count = 0
    @passenger_count = 0
  end

  def accept_train(train_new)
    @trains.append(train_new)
    train_new.stop
  end

  def trains_on_the_station
    @trains.each { |train| puts train.number }
  end

  def freight_trains
    @trains.each do |train|
      if train.type == 'freight'
        @freight_count += 1
      end
    end
  end

  def passenger_trains
    @trains.each do |train|
      if train.type == 'passenger'
        @passenger_count += 1
      end
    end
  end

  def send_train(train_to_remove)
    @trains.delete(train_to_remove)
  end
end

# class route contains stations
class Route
  attr_reader :start_station, :end_station, :list_of_stations
  def initialize(start_station, end_station)
    @start_station = start_station
    @end_station = end_station
    @list_of_stations = [start_station, end_station]
  end

  def add_station(new_station)
    @list_of_stations.insert(@list_of_stations.length - 1, new_station)
  end

  def remove_station(needed_station)
    @list_of_stations.delete(needed_station)
  end

  def show_route
    @list_of_stations.each { |station| puts station.name }
  end
end

# class train contains number, type, amount of vagons and route
class Train
  attr_reader :amount_of_vagons, :number, :type, :speed, :own_route
  def initialize(number, type, amount_of_vagons)
    @number = number
    @type = type
    @amount_of_vagons = amount_of_vagons
    @speed = 0
    @station_index = 0
    @own_route = 0
  end

  def gain_speed(gain)
    @speed += gain
  end

  def stop
    @speed = 0
  end

  def add_vagon
    @amount_of_vagons += 1 if @speed.zero?
  end

  def remove_vagon
    @amount_of_vagons -= 1 if @speed.zero? && @amount_of_vagons > 0
  end

  def new_route(own_route)
    @own_route = own_route
    @own_route.start_station.accept_train(self)
  end

  def move_train_next
    unless @station_index == @own_route.list_of_stations.length
      @station_index += 1
    end
    own_route.list_of_stations[@station_index].accept_train(self)
  end

  def move_train_back
    unless @station_index.zero?
      @station_index -= 0
    end
    own_route.list_of_stations[@station_index].accept_train(self)
  end

  def trains_current_station
    return @own_route.list_of_stations[@station_index]
  end

  def trains_previous_station
    unless @station_index == 0
      return @own_route.list_of_stations[@station_index - 1]
    end
  end

  def trains_next_station
    unless @station_index == @own_route.list_of_stations.length
      return @own_route.list_of_stations[@station_index + 1]
    end
  end
end
