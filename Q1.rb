class Station 
  def initialize(name, trains = [])
      @name = name
      @trains = trains
  end

  def accept_train(train_new)
    if train_new.instans_of? Trains
      @trains.append(train_new)
    end
  end

  def trains_on_the_station
    return (@trains)
  end

  def freight_trains
    for train in @trains
      if train.type == freight
        @freight_list.append(train)
      end
    end
    return (@freight_list)
  end

  def passenger_trains
    for train in @trains 
      if train.type == passenger 
        @passenger_list.append(train)
      end
    end
    return(@passenger_list)
  end

  def send_train(train_to_remove)
    @trains.remove(train_to_remove)
end

class Route
  def initialize(start_station, end_station, list_of_stations = [start_station, end_station] )
    @start_station = start_station
    @end_station = end_station
  end

  def add_station() 
    @list_of_stations.insert(@list_of_stations.length - 1, new_station)
  end 

  def remove_station(needed_station)
    @list_of_stations.remove(needed_station) 
  end

  def show_route
    return(@list_of_stations)
  end
end

class Train
  attr_reader :amount_of_railways
  def initialize(number, type, amount_of_railways, speed = 0)
    @number = number 
    @type = type
    @amount_of_railways = amount_of_railways
    @speed = speed
  end

  def railways_amount
    return(amount_of_railways)
  end

  def gain_speed(gain)
    @speed = @speed + gain 
  end

  def stop 
    @speed = 0
  end

  def add_railway 
    if @speed == 0 
      @amount_of_railways += 1
    end
  end

  def remove_railway 
    if @speed == 0 and @amount_of_railways > 0
      @amount_of_railways -= 1
    end
  end

  def set_route(own_route) 
    @own_route = own_route
    if @own_route.instans_of? Route
      @current_station = Route.start_station
      @station_index = 0
      Station.name(Route.start_station).trains.append(self)
    end
  end

  def move_train_next
    if @current_station != @end_station  
      @current_station = @own_route.list_of_stations[@station_index + 1] 
      @stations_now = [Route.list_of_stations[@station_index], Route.list_of_stations[@station_index -1], Route.list_of_stations[@station_index + 1]]
      return(@stations_now)    
    end

  end

  def move_train_back
    if @current_station != @start_station
      @current_station = @own_route.list_of_stations[@station_index - 1]
      @stations_now = [Route.list_of_stations[@station_index], Route.list_of_stations[@station_index + 1], Route.list_of_stations[@station_index - 1]]
      return(@stations_now) 
    end 
  end
end
end    

