require_relative 'modules'
# class route contains stations
class Route
  include InstanceCounter
  attr_reader :start_station, :end_station, :list_of_stations, :route_name

  @@instances = []

  def self.all
    @@instances
  end

  def initialize(route_name, start_station, end_station)
    @route_name = route_name
    @list_of_stations = [start_station, end_station]
    @@instances.append(self)
    validate!
  end

  def add_station(new_station)
    @list_of_stations.insert(@list_of_stations.length - 1, new_station)
  end

  def remove_station(needed_station)
    @list_of_stations.delete(needed_station)
  end
end

def valid?
  validate!
rescue
  false
end

def validate!
  raise "Поле названия маршрута не может быть пустым!" if route_name == ''
  true
end
