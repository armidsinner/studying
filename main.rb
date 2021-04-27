require_relative 'station'
require_relative 'train'
require_relative 'route'
require_relative 'passenger_train'
require_relative 'vagon'
require_relative 'cargo_train'
require_relative 'cargo_vagon'
require_relative 'passenger_vagon'
require_relative 'modules'

class Interface
  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def start_using
    a = 'none'
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
      0) Завершить программу'
      a = gets.chomp
      case a
      when '1'
        begin 
          create_station
        rescue RuntimeError => e
          puts e.inspect
          puts "Введите название станции повторно!"
          retry
        end
      when '2'
        begin
          create_train
        rescue RuntimeError => e
          puts e.inspect
          puts "Введите название, начальную и конечную станцию повторно!"
          retry
        end
      when '3'
        begin 
          create_route
        rescue RuntimeError => e
          puts e.inspect
          puts "Введите повторно!"
          retry
        end
      when '4'
        add_station_to_the_route
      when '5'
        delete_station_from_the_route
      when '6'
        set_route
      when '7'
        add_remove_vagon
      when '8'
        show_stations
      when '9'
       trains_on_the_station
      when '10'
        move_train
      end
    end
  end

  private

  def create_station
    puts 'Введите название станции'
    name = gets.chomp
    name = Station.new(name)
    @stations.append(name)
  end

  def create_train
    puts 'Создать грузовой или пассажирский поезд?
    Чтобы создать грузовой, нажмите 1.
    Чтобы создать пассажирский, нажмите 2'
    a = gets.chomp
    case a
    when '1'
      puts 'Введите номер поезда'
      number = gets.chomp
      number = CargoTrain.new(number)
      puts "Создан поезд с номером #{number.number}, это поезд типа #{number.type}"
      @trains.append(number)
    when '2'
      number = gets.chomp
      number = PassengerTrain.new(number)
      puts "Создан поезд с номером #{number.number}, это поезд типа #{number.type}"
      @trains.append(number)
    end
  end

  def create_route
    puts 'Введите название маршрута, начальную и кoнечную станцию'
    route_name = gets.chomp
    start_station = gets.chomp
    end_station = gets.chomp
    route_name = Route.new(route_name, start_station, end_station)
    @routes.append(route_name)
  end

  def add_station_to_the_route
    puts 'Список маршрутов:'
    counter = 0
    @routes.each do |route|
      print counter.to_s + ')' + route.list_of_stations[0].name + '-' + route.list_of_stations[-1].name
      counter += 1
      puts
    end
    puts 'В какой маршрут хотите добавить станцию?'
    needed_route = gets.chomp
    puts 'Список станций:'
    counter = 0
    @stations.each do |station|
      unless new_routes[needed_route.to_i].list_of_stations.include? station
        print counter.to_s + ')' + station.name
        counter += 1
        puts
      end
    end
    puts 'Какую станцию хотите добавить?'
    needed_station = gets.chomp
    @routes[needed_route.to_i].add_station(@stations[needed_station.to_i])
  end

  def delete_station_from_the_route
    puts 'Список маршрутов:'
    counter = 0
    @routes.each do |route|
      print counter.to_s + ')' + route.list_of_stations[0].name + '-' + route.list_of_stations[-1].name
      counter += 1
      puts
    end
    puts 'Из какого маршрута хотите удалить станцию?'
    needed_route = gets.chomp
    puts 'Список станций в данном маршруте:'
    counter = 0
    @stations[needed_route.to_i].list_of_stations.each do |station|
      print counter.to_s + ')' + station.name
      counter += 1
      puts
    end
    puts 'Какую станцию хотите удалить?'
    needed_station = gets.chomp
    @routes[needed_route.to_i].remove_station(@stations[needed_station.to_i])
  end

  def set_route
    puts 'Список всех поездов:'
    counter = 0
    @trains.each do |train|
      print counter.to_s + ')' + train.number
      counter += 1
      puts
    end
    puts 'Для какого поезда хотите задать маршрут'
    needed_train = gets.chomp
    puts 'Список маршрутов:'
    counter = 0
    @routes.each do |route|
      print counter.to_s + ')' + route.list_of_stations[0].name + '-' + route.list_of_stations[-1].name
      counter += 1
      puts
    end
    puts 'Какой из существующих маршрутов присвоить?'
    needed_route = gets.chomp
    @trains[needed_train.to_i].new_route(@routes[needed_route.to_i])
  end

  def add_remove_vagon
    puts 'Список всех поездов:'
    counter = 0
    @trains.each do |train|
      print counter.to_s + ')' + train.number
      counter += 1
      puts
    end
    puts 'Какому поезду хотите добавить вагон?'
    needed_train = gets.chomp
    puts 'Чтобы добавить вагон к поезду, нажмите 1
    Чтобы отцепить вагон от поезда, нажмите 2'
    a = gets.chomp
    case a
    when '1'
      if @trains[needed_train.to_i].type == 'freight'
        new_vagon = CargoVagon.new
        @trains[needed_train.to_i].add_vagon(new_vagon)
      end
      if @trains[needed_train.to_i].type == 'passenger'
        new_vagon = PassengerVagon.new
        @trains[needed_train.to_i].add_vagon(new_vagon)
      end
    when '2'
      @trains[needed_train.to_i].remove_vagon
    end
  end

  def show_stations
    @stations.each { |station| puts station.name }
  end

  def trains_on_the_station 
    puts 'Список станций:'
    counter = 0
    @stations.each do |station|
      print counter.to_s + ')' + station.name
      counter += 1
      puts
    end
    puts 'Для какой станции отобразить список поездов?'
    needed_station = gets.chomp
    @stations[needed_station.to_i].trains.each { |train| puts train.number}
  end  

  def move_train 
    puts 'Список всех поездов:'
    counter = 0
    @trains.each do |train|
      print counter.to_s + ')' + train.number
      counter += 1
      puts
    end
    puts 'Какой поезд хотите переместить по маршруту'
    needed_train = gets.chomp
    puts 'Чтобы переместить поезд вперед по маршруту, нажмите 1
    Чтобы переместить поезд назад по маршруту, нажмите 2'
    a = gets.chomp
    case a
      when '1'
        @trains[needed_train.to_i].move_train_next
      when '2'
        @trains[needed_train.to_i].move_train_back
    end
  end
end
