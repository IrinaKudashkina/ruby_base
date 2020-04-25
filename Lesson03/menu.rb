class Menu
  MAIN = { 1 => :creation, 2 => :modification, 3 => :lists, 4 => :information, 0 => :exit_program }.freeze
  CREATION = {
    1 => :creation_station, 2 => :creation_route,
    3 => :creation_train, 4 => :creation_car, 0 => :main
  }.freeze
  MODIFICATION = {
    1 => :route_modification, 2 => :train_modification,
    3 => :car_modification, 0 => :main
  }.freeze
  LISTS = {
    1 => :all_stations, 2 => :trains_of_station,
    3 => :stations_of_route, 4 => :cars_of_train, 0 => :main
  }.freeze
  INFORMATION = { 1 => :find_train, 2 => :trains_by_type, 0 => :main }.freeze
  ROUTE_MODIFICATION = { 1 => :add_station, 2 => :delete_station, 0 => :modification }.freeze
  TRAIN_MODIFICATION = {
    1 => :train_assign_route, 2 => :train_forward,
    3 => :train_backward, 4 => :train_attach_car,
    5 => :train_detach_car, 0 => :main
  }.freeze
  PASSANGER_CAR_MODIFICATION = {
    1 => :passanger_car_load, 2 => :passanger_car_unload, 0 => :modification
  }.freeze
  CARGO_CAR_MODIFICATION = {
    1 => :cargo_car_load, 2 => :cargo_car_unload, 0 => :modification
  }.freeze

  def initialize
    puts "Добро пожаловать в программу управления железнодорожными станциями!"
    puts "Вы можете создавать станции, маршруты, поезда и легко управлять ими,"
    puts "внося необходимые изменения и формируя нужные списки."
    puts "Для начала работы с программой введите цифру:"
  end

  def main
    puts "Создание - 1  Внесение изменений - 2  Просмотр списков - 3  Информация - 4"
    menu_master(MAIN, :main)
  end

  private

  def menu_master(level, go_to, the_object = nil)
    cancel_choice
    user_choice = gets.chomp.to_i
    limit = level.keys.length - 1
    if the_object
      send(level[user_choice] || restart(limit, go_to), the_object)
    else
      send level[user_choice] || restart(limit, go_to)
    end
  end

  def creation
    puts "Создать:  Станцию - 1  Маршрут - 2  Поезд - 3  Вагон - 4"
    menu_master(CREATION, :creation)
  end

  def modification
    puts "Изменить:  Маршрут - 1  Поезд - 2  Вагон - 3"
    menu_master(MODIFICATION, :modification)
  end

  def lists
    puts "Список всех станций - 1  Список поездов на станции - 2"
    puts "Список станций маршрута - 3  Список вагонов поезда - 4"
    menu_master(LISTS, :lists)
  end

  def information
    puts "Информация: Найти поезд по номеру - 1  Количество поездов по видам - 2"
    menu_master(INFORMATION, :information)
  end

  def creation_station
    puts "Введите название станции"
    puts "[Название должно начинаться с буквы и может содержать в себе буквы,"\
         " цифры, дефисы и пробелы]"
    name = gets.chomp
    Station.new(name)
    puts "Станция '#{name}' создана!"
    creation
  rescue RuntimeError => e
    puts e.message
    creation_station
  end

  def creation_route
    limit = Station.all.length
    departure = creation_route_departure(limit)
    terminal = creation_route_terminal(limit)
    intermediates = creation_route_intermediates(limit)
    route = Route.new(Station.all[departure - 1], *intermediates, Station.all[terminal - 1])
    route_creation_message(route)
    creation
  end

  def route_creation_message(route)
    puts "Создан новый маршрут!"
    route_stations(route)
  end

  def creation_route_departure(limit)
    departure_message
    departure = gets.chomp.to_i
    check_choice(departure, limit, :creation)
    departure
  end

  def creation_route_terminal(limit)
    terminal_message
    terminal = gets.chomp.to_i
    check_choice(terminal, limit, :creation)
    terminal
  end

  def creation_route_intermediates(limit)
    intermediates = []
    loop do
      intermediates_message
      intermediate = gets.chomp.to_i
      break if intermediate == 99

      check_choice(intermediate, limit, :creation)
      intermediates << Station.all[intermediate - 1]
    end
    intermediates
  end

  def departure_message
    puts "Выберите НАЧАЛЬНУЮ станцию маршрута:"
    station_choice
  end

  def terminal_message
    puts "Выберите КОНЕЧНУЮ станцию маршрута:"
    station_choice
  end

  def intermediates_message
    puts "Добавить ПРОМЕЖУТОЧНУЮ станцию в маршрут:"
    station_choice
    puts "Закончить создание маршрута - 99"
  end

  def creation_train
    type, number, manufacturer = creation_transport("поезд")
    creation_train unless [1, 2].include?(type)
    creation_cargo_train(number, manufacturer) if type == 1
    creation_passenger_train(number, manufacturer) if type == 2
  rescue RuntimeError => e
    puts e.message
    creation_transport("поезд")
  end

  def creation_cargo_train(number, manufacturer)
    CargoTrain.new(number).manufacturer = manufacturer
    puts "Грузовой поезд c номером '#{number}' создан!"
    creation
  end

  def creation_passenger_train(number, manufacturer)
    PassengerTrain.new(number).manufacturer = manufacturer
    puts "Пассажирский поезд c номером '#{number}' создан!"
    creation
  end

  def creation_car
    type, number, manufacturer = creation_transport("вагон")
    creation_car unless [1, 2].include?(type)
    creation_cargo_car(number, manufacturer) if type == 1
    creation_passenger_car(number, manufacturer) if type == 2
  rescue RuntimeError => e
    puts e.message
    creation_transport("вагон")
  end

  def creation_cargo_car(number, manufacturer)
    puts "Введите объем грузового вагона (в куб.м.)"
    volume = gets.chomp
    CargoCar.new(number, volume).manufacturer = manufacturer
    puts "Грузовой вагон c номером '#{number}' создан!"
    creation
  end

  def creation_passenger_car(number, manufacturer)
    puts "Введите количество мест в пассажирском вагоне"
    seats = gets.chomp
    PassengerCar.new(number, seats).manufacturer = manufacturer
    puts "Пассажирский вагон c номером '#{number}' создан!"
    creation
  end

  def creation_transport(transport)
    type = type_of_transport(transport)
    number = number_of_transport(transport)
    manufacturer = manufacturer_of_transport(transport)
    [type, number, manufacturer]
  end

  def type_of_transport(transport)
    puts "Выберите тип #{transport}а:  Грузовой - 1  Пассажирский - 2"
    cancel_choice
    type = gets.chomp.to_i
    check_choice(type, 2, :creation)
    type
  end

  def number_of_transport(transport)
    puts "Введите номер #{transport}а"
    if transport == "поезд"
      puts "[Номер должен включать 5 букв или цифр, допустимые форматы XXX-XX или XXXXX]"
    else
      puts "Номер должен включать в себя только буквы и цифры, от 5 до 10 символов"
    end
    gets.chomp.to_s
  end

  def manufacturer_of_transport(transport)
    puts "Введите название компании-производителя #{transport}а"
    gets.chomp.to_s
  end

  def route_modification
    puts "Изменение маршрута:  Добавить станцию - 1  Удалить станцию - 2"
    menu_master(ROUTE_MODIFICATION, :route_modification)
  end

  def add_station
    route, route_name = the_route
    puts "Выберите станцию, которую нужно добавить в маршрут '#{route_name}'"
    station = the_station
    route.add_station(station)
    puts "Станция '#{station.name}' добавлена в маршрут '#{route_name}'!"
    route_stations(route)
    route_modification
  end

  def delete_station
    route, route_name = the_route
    puts "Выберите станцию маршрута '#{route_name}', которую нужно удалить"
    station = station_for_delete(route)
    route.delete_station(station)
    puts "Станция '#{station.name}' удалена из маршрута '#{route_name}'!"
    route_stations(route)
    route_modification
  end

  def station_for_delete(route)
    all_route_intermediates(route)
    limit = route.intermediates.length
    station_number = gets.chomp.to_i
    check_choice(station_number, limit, :route_modification)
    route.intermediates[station_number - 1]
  end

  def all_route_intermediates(route)
    route.intermediates.each.with_index(1) { |station, index| puts "#{station.name} - #{index}" }
    cancel_choice
  end

  def train_modification
    train = the_train
    puts "Поезд: Внесите изменение (от 1 до 5):
    Назначить маршрут - 1  Переместить вперед - 2  Переместить назад - 3
    Прицепить вагон - 4  Отцепить вагон - 5"
    menu_master(TRAIN_MODIFICATION, :modification, train)
  end

  def train_assign_route(train)
    route, route_name = the_route
    train.assign_route(route)
    puts "Поезду '#{train.number}' назначен маршрут '#{route_name}'!"
    modification
  end

  def train_forward(train)
    if train.route
      train.forward
    else
      no_route
    end
    modification
  end

  def train_backward(train)
    if train.route
      train.backward
    else
      no_route
    end
    modification
  end

  def train_attach_car(train)
    puts "Тип поезда #{train.type}"
    car = the_car(train.type)
    train.attach_car(car)
    puts "К поезду '#{train.number}' прицеплен вагон '#{car.number}'!"
    train_cars(train)
    modification
  end

  def train_detach_car(train)
    puts "Выберите вагон:"
    car = car_to_detach(train)
    train.detach_car(car)
    puts "От поезда '#{train.number}' отцеплен вагон '#{car.number}'!"
    train_cars(train)
    modification
  end

  def car_to_detach(train)
    all_train_cars(train)
    limit = train.cars.length
    car_number = gets.chomp.to_i
    check_choice(car_number, limit, :modification)
    train.cars[car_number - 1]
  end

  def all_train_cars(train)
    train.cars.each.with_index(1) { |car, index| puts "вагон номер '#{car.number}' - #{index}" }
    cancel_choice
  end

  def car_modification
    car = the_car
    passenger_car_modification(car) if car.type == Car::CAR_TYPES[1]
    cargo_car_modification(car) if car.type == Car::CAR_TYPES[0]
  rescue RuntimeError => e
    puts e.message
    car_modification
  end

  def passenger_car_modification(car)
    puts "Занять место - 1  Освободить место - 2"
    menu_master(PASSANGER_CAR_MODIFICATION, :car_modification, car)
  end

  def cargo_car_modification(car)
    puts "Загрузить вагон - 1  Разгрузить вагон - 2"
    menu_master(CARGO_CAR_MODIFICATION, :car_modification, car)
  end

  def passanger_car_load(car)
    car.load
    puts "Место занято!"
    car_seats(car)
    car_modification
  end

  def passanger_car_unload(car)
    car.unload
    puts "Место освобождено!"
    car_seats(car)
    car_modification
  end

  def cargo_car_load(car)
    puts "Введите объем груза для загрузки (в куб.м.)"
    volume = gets.chomp.to_f
    car.load(volume)
    puts "Загружено #{volume} куб.м.!"
    car_volume(car)
    car_modification
  end

  def cargo_car_unload(car)
    puts "Введите объем груза для разрузки (в куб.м.)"
    volume = gets.chomp.to_f
    car.unload(volume)
    puts "Выгружено #{volume} куб.м.!"
    car_volume(car)
    car_modification
  end

  def the_station
    puts "Выберите станцию:"
    station_choice
    limit = Station.all.length
    station_number = gets.chomp.to_i
    check_choice(station_number, limit, :route_modification)
    Station.all[station_number - 1]
  end

  def the_route
    route_choice
    limit = Route.all.length
    route_number = gets.chomp.to_i
    check_choice(route_number, limit, :route_modification)
    route = Route.all[route_number - 1]
    name = "#{route.departure.name}-#{route.terminal.name}"
    [route, name]
  end

  def the_train
    train_choice
    limit = Train.all.length
    train_number = gets.chomp.to_i
    check_choice(train_number, limit, :modification)
    Train.all[train_number - 1]
  end

  def the_car(type = nil)
    puts "Выберите вагон:"
    return any_type_car unless Train::TRAIN_TYPES.include?(type)
    return the_cargo_car if type == Train::TRAIN_TYPES[0]

    the_passenger_car if type == Train::TRAIN_TYPES[1]
  end

  def the_cargo_car
    all_cargo_cars
    car_cancel_choice
    limit = Car.cargo_car_list.length
    car_number = gets.chomp.to_i
    check_choice(car_number, limit, :modification)
    Car.cargo_car_list[car_number - 1]
  end

  def all_cargo_cars
    Car.cargo_car_list.each.with_index(1) do |car, index|
      puts "#{car.type} вагон номер '#{car.number}' - #{index}"
    end
  end

  def the_passenger_car
    all_passenger_cars
    car_cancel_choice
    limit = Car.passenger_car_list.length
    car_number = gets.chomp.to_i
    check_choice(car_number, limit, :modification)
    Car.passenger_car_list[car_number - 1]
  end

  def all_passenger_cars
    Car.passenger_car_list.each.with_index(1) do |car, index|
      puts "#{car.type} вагон номер '#{car.number}' - #{index}"
    end
  end

  def any_type_car
    all_cars
    car_cancel_choice
    limit = Car.all.length
    car_number = gets.chomp.to_i
    check_choice(car_number, limit, :modification)
    Car.all[car_number - 1]
  end

  def all_cars
    Car.all.each.with_index(1) do |car, index|
      puts "#{car.type} вагон номер #{car.number} - #{index}"
    end
  end

  def station_choice
    Station.all.each.with_index(1) { |station, index| puts "#{station.name} - #{index}" }
    cancel_choice
    puts "(Если станции нет в списке, то сначала нужно ее создать)"
  end

  def route_choice
    puts "Выберите маршрут:"
    Route.all.each.with_index(1) do |route, index|
      puts "маршрут '#{route.departure.name}-#{route.terminal.name}' - #{index}"
    end
    cancel_choice
    puts "(Если маршрута нет в списке, то сначала нужно его создать)"
  end

  def train_choice
    puts "Выберите поезд из списка:"
    Train.all.each.with_index(1) do |train, index|
      puts "#{train.type} поезд номер #{train.number} - #{index}"
    end
    cancel_choice
    puts "(Если поезда с нужным номером нет в списке, то сначала его нужно создать)"
  end

  def car_cancel_choice
    cancel_choice
    puts "(Если вагона с нужным номером нет в списке, то сначала его нужно создать)"
  end

  def cancel_choice
    puts "[Отмена - 0]"
  end

  def check_choice(number, limit, menu_cancel, menu_limit = menu_cancel)
    send(menu_cancel) if number.zero?
    return unless number > limit

    no_number
    send(menu_limit)
  end

  def route_stations(route)
    puts "Маршрут '#{route.departure.name}-#{route.terminal.name}'. Станции маршрута:"
    route.stations_list.each { |station| puts station.name }
  end

  def station_trains(station)
    if station.trains.empty?
      puts "На станции #{station.name}' нет поездов"
    else
      puts "На станции #{station.name}' находятся поезда:"
      station.trains_do do |train|
        puts "   Поезд номер '#{train.number}', тип '#{train.type}',"\
             " количество вагонов: #{train.cars_count}"
      end
    end
  end

  def train_cars(train)
    puts "Поезд '#{train.number}' производства компании '#{train.manufacturer}'. Вагоны поезда:"
    puts "Нет вагонов!" if train.cars.empty?
    train_cargo_cars(train) if train.type == Train::TRAIN_TYPES[0]
    train_passenger_cars(train) if train.type == Train::TRAIN_TYPES[1]
  end

  def train_cargo_cars(train)
    train.cars_do do |car|
      puts "   Вагон номер '#{car.number}', тип '#{car.type}', "\
           "свободно #{car.available_volume} куб.м., занято #{car.occupied_volume} куб.м."
    end
  end

  def train_passenger_cars(train)
    train.cars_do do |car|
      puts "   Вагон номер '#{car.number}', тип '#{car.type}', "\
           "свободно мест: #{car.available_seats}, занято мест: #{car.occupied_seats}"
    end
  end

  def car_seats(car)
    puts "В пассажирском вагоне номер '#{car.number}' занято мест: #{car.occupied_seats}, "\
         " свободно мест: #{car.available_seats}"
  end

  def car_volume(car)
    puts "В грузовом вагоне номер '#{car.number}' занято #{car.occupied_volume} куб.м., "\
         "свободно #{car.available_volume} куб.м."
  end

  def no_number
    puts "Нет выбора с таким номером!"
  end

  def no_route
    puts "Поезду не назначен маршрут!"
  end

  def exit_program
    puts "Спасибо за работу с программой!"
  end

  def restart(limit, go_to)
    puts "Введите цифру от 0 до #{limit}"
    go_to
  end

  def all_stations
    puts "Все станции железной дороги:"
    Station.all.each.with_index(1) do |station, index|
      puts "#{index}. Станция '#{station.name}'"
      station_trains(station)
    end
    lists
  end

  def trains_of_station
    station = the_station
    station_trains(station)
    lists
  end

  def stations_of_route
    route = the_route[0]
    route_stations(route)
    lists
  end

  def cars_of_train
    train = the_train
    train_cars(train)
    lists
  end

  def find_train
    puts "Введите номер поезда"
    number_choice = gets.chomp.to_s
    train = Train.find(number_choice)
    puts "Поезд номер '#{train.number}': тип '#{train.type}',"\
             " компания-производитель '#{train.manufacturer}'."
    information
  rescue RuntimeError => e
    puts e.message
    information
  end

  def trains_by_type
    passenger_trains = PassengerTrain.instances
    cargo_trains = CargoTrain.instances
    puts "Поездов пассажирских: #{passenger_trains}"
    puts "Поездов грузовых: #{cargo_trains}"
    puts "Всего поездов: #{passenger_trains + cargo_trains}"
    information
  end
end
