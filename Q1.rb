# class station contains name, list of trains, types of trains
class Station
  attr_reader :name, :trains, :freight_list, :passenger_list
  def initialize(name)
    @name = name
    @trains = []
    @freight_list = []
    @passenger_list = []
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
        @freight_list.append(train.number)
      end
    end
    puts @freight_list
  end

  def passenger_trains
    @trains.each do |train|
      if train.type == 'passenger'
        @passenger_list.append(train.number)
      end
    end
    puts @passenger_list
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

# class train contains number, type, amount of railways and route
class Train
  attr_reader :amount_of_railways, :number, :type, :speed, :own_route, :current_station
  def initialize(number, type, amount_of_railways)
    @number = number
    @type = type
    @amount_of_railways = amount_of_railways
    @speed = 0
    @station_index = 0
    @current_station = 0
    @own_route = []
  end

  def gain_speed(gain)
    @speed += gain
  end

  def stop
    @speed = 0
  end

  def add_railway
    @amount_of_railways += 1 if @speed.zero?
  end

  def remove_railway
    @amount_of_railways -= 1 if @speed.zero? && @amount_of_railways > 0
  end

  def new_route(own_route)
    @own_route = own_route
    @current_station = own_route.start_station
    @station_index = 0
    own_route.start_station.accept_train(self)
  end

  def move_train_next
    unless @current_station == @end_station
      @station_index += 1 
      @current_station = @own_route.list_of_stations[@station_index]
      @stations_now = [own_route.list_of_stations[@station_index - 1],
                       own_route.list_of_stations[@station_index],
                       own_route.list_of_stations[@station_index + 1]]
      @stations_now.each { |station| puts station.name }
      current_station.accept_train(self)
    end
  end

  def move_train_back
    if @current_station != @start_station
      @current_station = @own_route.list_of_stations[@station_index - 1]
      @stations_now = [own_route.list_of_stations[@station_index],
                       own_route.list_of_stations[@station_index + 1],
                       own_route.list_of_stations[@station_index - 1]]
      @stations_now.each { |station| puts station.name }
      current_station.accept_train(self)
    end
  end
end




