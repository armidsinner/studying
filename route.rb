require_relative 'modules'
# class route contains stations
class Route
  include InstanceCounter
  attr_reader :start_station, :end_station, :list_of_stations

  @@instances = []

  def Route.all
    @@instances
  end

  def initialize(start_station, end_station)
    @list_of_stations = [start_station, end_station]
    @@instances.append(self)
  end

  # Методы ниже вызываются из пользовательского кода следовательно, они public

  def add_station(new_station)
    @list_of_stations.insert(@list_of_stations.length - 1, new_station)
  end

  def remove_station(needed_station)
    @list_of_stations.delete(needed_station)
  end
end
