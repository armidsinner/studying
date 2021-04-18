require_relative 'station'
require_relative 'train'
require_relative 'route'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'cargo_vagon'
require_relative 'passenger_vagon'

a = nil 
new_stations = []
new_trains = []
new_routes = []

while a != '0'
  puts 'Выберите действие, введя цифру:
  1) Создать станцию
  2) Создать поезд
  3) Создать маршрут
  4) Добавить станцию в маршрут
  5) Удалить станцию из маршрута
  6) Назначить поезду маршрут
  7) Добавить/отцепить вагон к поезду
  8) Показать список станций
  9) Показать список поездов на станции
  10) Переместить поезд по маршруту
  0) Выйти из программы'
  a = gets.chomp
  if a == '1'
    puts 'Введите название станции'
    name = gets.chomp
    name = Station.new(name)
    new_stations.append(name)
  end
  if a == '2'
    puts 'Создать грузовой или пассажирский поезд?
    Чтобы создать грузовой, нажмите 1.
    Чтобы создать пассажирский, нажмите 2'
    a = gets.chomp
    if a == '1'
      puts 'Введите номер поезда'
      number = gets.chomp
      number = CargoTrain.new(number)
      new_trains.append(number)
    end
    if a == '2'
      puts 'Чтобы создать пассажирский поезд, нажмите 1
      Чтобы создать грузовой поезд, нажмите 2'
      a = gets.chomp
      if a == '1'
        puts 'Введите номер поезда'
        number = gets.chomp
        number = PassengerTrain.new(number)
        new_trains.append(number)
      end
      if a == '2'
        puts 'Введите номер поезда'
        number = gets.chomp
        number = CargoTrain.new(number)
        new_trains.append(number)
      end
    end
  end
  if a == '3'
    puts 'Введите название маршрута, начальную и кoнечную станцию'
    route_name = gets.chomp
    start_station = gets.chomp
    end_station = gets.chomp
    route_name = Route.new(start_station, end_station)
    new_routes.append(route_name)
  end
  if a == '4'
    puts 'Список маршрутов:'
    counter = 0
    new_routes.each do |route|
      print counter.to_s + ')' + route.list_of_stations[0].name + '-' + route.list_of_stations[-1].name
      counter += 1
      puts
    end
    puts 'В какой маршрут хотите добавить станцию?'
    needed_route = gets.chomp
    puts 'Список станций:'
    counter = 0
    new_stations.each do |station|
      unless new_routes[needed_route.to_i].list_of_stations.include? station
      print counter.to_s + ')' + station.name
      counter += 1
      puts
      end
    end
    puts 'Какую станцию хотите добавить?'
    needed_station = gets.chomp
    new_routes[needed_route.to_i].add_station(new_stations[needed_station.to_i])
  end
  if a == '5'
    puts 'Список маршрутов:'
    counter = 0
    new_routes.each do |route|
      print counter.to_s + ')' + route.list_of_stations[0].name + '-' + route.list_of_stations[-1].name
      counter += 1
      puts
    end
    puts 'Из какого маршрута хотите удалить станцию?'
    needed_route = gets.chomp
    puts 'Список станций в данном маршруте:'
    counter = 0
    new_stations[needed_route.to_i].list_of_stations.each do |station|
      print counter.to_s + ')' + station.name
      counter += 1
      puts
    end
    puts 'Какую станцию хотите удалить?'
    needed_station = gets.chomp
    new_routes[needed_route.to_i].remove_station(new_stations[needed_station.to_i])
  end
  if a == '6'
    puts 'Список всех поездов:'
    counter = 0
    new_trains.each do |train|
      print counter.to_s + ')' + train.number
      counter += 1
      puts
    end
    puts 'Для какого поезда хотите задать маршрут'
    needed_train = gets.chomp
    puts 'Список маршрутов:'
    counter = 0
    new_routes.each do |route|
      print counter.to_s + ')' + route.list_of_stations[0].name + '-' + route.list_of_stations[-1].name
      counter += 1
      puts
    end
    puts 'Какой из существующих маршрутов присвоить?'
    needed_route = gets.chomp
    new_trains[needed_train.to_i].new_route(new_routes[needed_route.to_i])
  end
  if a == '7'
    puts 'Список всех поездов:'
    counter = 0
    new_trains.each do |train|
      print counter.to_s + ')' + train.number
      counter += 1
      puts
    end
    puts 'Какому поезду хотите добавить вагон?'
    needed_train = gets.chomp
    puts 'Чтобы добавить вагон к поезду, нажмите 1
    Чтобы отцепить вагон от поезда, нажмите 2'
    a = gets.chomp
    if a == '1'
      if new_trains[needed_train.to_i].type == 'freight'
        new_vagon = CargoVagon.new
        new_trains[needed_train.to_i].add_vagon(new_vagon)
      end
      if new_trains[needed_train.to_i].type == 'passenger'
        new_vagon = PassengerVagon.new
        new_trains[needed_train.to_i].add_vagon(new_vagon)
      end
    end
    if a == '2'
      new_trains[needed_train.to_i].remove_vagon
    end
  end
  if a == '8'
  new_stations.each { |station| puts station.name }
  end
  if a == '9'
    puts 'Список станций:'
    counter = 0
    new_stations.each do |station|
      print counter.to_s + ')' + station.name
      counter += 1
      puts
    end
    puts 'Для какой станции отобразить список поездов?'
    needed_station = gets.chomp
    new_stations[needed_station.to_i].trains.each { |train| puts train.number }
  end
  if a == '10'
  puts 'Список всех поездов:'
    counter = 0
    new_trains.each do |train|
      print counter.to_s + ')' + train.number
      counter += 1
      puts
    end
  puts 'Какой поезд хотите переместить по маршруту'
  needed_train = gets.chomp
  puts 'Чтобы переместить поезд вперед по маршруту, нажмите 1
  Чтобы переместить поезд назад по маршруту, нажмите 2'
  a = gets.chomp
  if a == '1'
    new_trains[needed_train.to_i].move_train_next
  end
  if a == '2'
    new_trains[needed_train.to_i].move_train_back
  end
  end
end



