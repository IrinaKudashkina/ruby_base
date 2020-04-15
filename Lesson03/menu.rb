class Menu
  # можно потом сделать создание объектов Menu для разных пользователей
  # можно потом сохранять созданные станции, поезда и прочее в объект Menu, а его - в файл

  def initialize
    puts "Добро пожаловать в программу управления железнодорожными станциями!"
    puts "Вы можете создавать станции, маршруты, поезда и легко управлять ими,"
    puts "внося необходимые изменения и формируя нужные списки."
    puts "Для начала работы с программой введите цифру:"
  end

  def main
    puts "Создание - 1  Внесение изменений - 2  Просмотр списков - 3  Информация - 4"
    puts "[Завершить работу с программой - 0]"
    user_choice = gets.chomp.to_i
    case user_choice
    when 1
      creation
    when 2
      modification
    when 3
      lists
    when 4
      information
    when 0
      puts "Спасибо за работу с программой!"
    else
      puts "Введите цифру от 0 до 4"
      main
    end
  end

  private
  # Вызов методов ниже отдельно от Menu.main не имеет смысла пока объекты класса Menu не сохраняются
  # private потому что класс Menu не имеет потомков

  def creation
    puts "Создать:  Станцию - 1  Маршрут - 2  Поезд - 3  Вагон - 4"
    cancel_choice
    user_choice = gets.chomp.to_i
    case user_choice
    when 1
      creation_station
    when 2
      creation_route
    when 3
      creation_train
    when 4
      creation_car
    when 0
      main
    else
      puts "Введите цифру от 0 до 4"
      creation
    end
  end

  def modification
    puts "Изменить:  Маршрут - 1  Поезд - 2  Вагон - 3"
    cancel_choice
    user_choice = gets.chomp.to_i
    case user_choice
    when 1
      route_modification
    when 2
      train_modification
    when 3
      car_modification
    when 0
      main
    else
      puts "Введите цифру от 0 до 3"
      modification
    end
  end

  def lists
    puts "Список всех станций - 1  Список поездов на станции - 2"
    puts  "Список станций маршрута - 3  Список вагонов поезда - 4"
    cancel_choice
    user_choice = gets.chomp.to_i
    case user_choice
    when 1
      puts "Все станции железной дороги:"
      Station.all.each.with_index(1) do |station, index|
        puts "#{index}. Станция '#{station.name}'"
        station_trains(station)
      end
      lists
    when 2
      station = the_station
      station_trains(station)
      lists
    when 3
      route = the_route[0]
      route_stations(route)
      lists
    when 4
      train = the_train
      train_cars(train)
      lists
    when 0
      main
    else
      puts "Введите цифру от 0 до 4"
      lists
    end
  end

  def information
    puts "Информация: Найти поезд по номеру - 1  Количество поездов по видам - 2"
    cancel_choice
    user_choice = gets.chomp.to_i
    case user_choice
    when 1
      puts "Введите номер поезда"
      number_choice = gets.chomp.to_s
      train = Train.find(number_choice)
      puts "Поезд номер '#{train.number}': тип '#{train.type}', компания-производитель '#{train.manufacturer}'."
      information
    when 2
      passenger_trains = PassengerTrain.instances
      cargo_trains = CargoTrain.instances
      puts "Поездов пассажирских: #{passenger_trains}"
      puts "Поездов грузовых: #{cargo_trains}"
      puts "Всего поездов: #{passenger_trains + cargo_trains}"
      information
    when 0
      main
    else
      puts "Введите цифру от 0 до 2"
      lists
    end
  end

  def creation_station
    puts "Введите название станции"
    puts "[Название должно начинаться с буквы и может содержать в себе буквы, цифры, дефисы и пробелы]"
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
    intermediates = []
    puts "Выберите НАЧАЛЬНУЮ станцию маршрута:"
    station_choice
    departure = gets.chomp.to_i
    check_choice(departure, limit, :creation)
    puts "Выберите КОНЕЧНУЮ станцию маршрута:"
    station_choice
    terminal = gets.chomp.to_i
    check_choice(terminal, limit, :creation)
    loop do
      puts "Добавить ПРОМЕЖУТОЧНУЮ станцию в маршрут:"
      station_choice
      puts "Закончить создание маршрута - 99"
      intermediate = gets.chomp.to_i
      break if intermediate == 99
      check_choice(intermediate, limit, :creation)
      intermediates << Station.all[intermediate - 1]
    end
    puts "Создан новый маршрут!"
    route = Route.new(Station.all[departure - 1], *intermediates, Station.all[terminal - 1])
    route_stations(route)
    creation
  end

  def creation_train
    type, number, manufacturer = creation_transport('поезд')
    case type
    when 1
      CargoTrain.new(number).manufacturer = manufacturer
      puts "Грузовой поезд c номером '#{number}' создан! Компания-производитель: '#{manufacturer}'"
      creation
    when 2
      PassengerTrain.new(number).manufacturer = manufacturer
      puts "Пассажирский поезд c номером '#{number}' создан! Компания-производитель: '#{manufacturer}'"
      creation
    else
      creation_train
    end
  rescue RuntimeError => e
    puts e.message
    creation_transport('поезд')
  end

  def creation_car
    type, number, manufacturer = creation_transport('вагон')
    case type
    when 1
      puts "Введите объем грузового вагона (в куб.м.)"
      volume = gets.chomp
      CargoCar.new(number, volume).manufacturer = manufacturer
      puts "Грузовой вагон c номером '#{number}' создан! Компания-производитель: '#{manufacturer}'"
      creation
    when 2
      puts "Введите количество мест в пассажирском вагоне"
      seats = gets.chomp
      PassengerCar.new(number, seats).manufacturer = manufacturer
      puts "Пассажирский вагон c номером '#{number}' создан! Компания-производитель: '#{manufacturer}'"
      creation
    else
      creation_car
    end
  rescue RuntimeError => e
    puts e.message
    creation_transport('вагон')
  end

  def creation_transport(transport)
    puts "Выберите тип #{transport}а:  Грузовой - 1  Пассажирский - 2"
    cancel_choice
    type = gets.chomp.to_i
    check_choice(type, 2, :creation)
    puts "Введите номер #{transport}а"
    if transport == 'поезд'
      puts "[Номер должен включать 5 букв или цифр, допустимые форматы XXX-XX или XXXXX]"
    else
      puts "Номер должен включать в себя только буквы и цифры, от 5 до 10 символов"
    end
    number = gets.chomp.to_s
    puts "Введите название компании-производителя #{transport}а"
    manufacturer = gets.chomp.to_s
    [type, number, manufacturer]
  end

  def route_modification
    puts "Изменение маршрута:  Добавить станцию - 1  Удалить станцию - 2"
    cancel_choice
    user_choice = gets.chomp.to_i
    case user_choice
    when 1
      route, route_name = the_route
      puts "Выберите станцию, которую нужно добавить в маршрут '#{route_name}'"
      station = the_station
      route.add_station(station)
      puts "Станция '#{station.name}' добавлена в маршрут '#{route_name}'!"
      route_stations(route)
      route_modification
    when 2
      route, route_name = the_route
      puts "Выберите станцию маршрута '#{route_name}', которую нужно удалить"
      route.intermediates.each.with_index(1) { |station, index| puts "#{station.name} - #{index}" }
      cancel_choice
      limit = route.intermediates.length
      station_number = gets.chomp.to_i
      check_choice(station_number, limit, :route_modification)
      station = route.intermediates[station_number - 1]
      route.delete_station(station)
      puts "Станция '#{station.name}' удалена из маршрута '#{route_name}'!"
      route_stations(route)
      route_modification
    when 0
      modification
    else
      puts "Введите цифру от 0 до 2"
      route_modification
    end
  end

  def train_modification
    train = the_train
    puts "Поезд: Внесите изменение (от 1 до 5):
    Назначить маршрут - 1  Переместить вперед - 2  Переместить назад - 3
    Прицепить вагон - 4  Отцепить вагон - 5"
    cancel_choice
    user_choice = gets.chomp.to_i
    case user_choice
    when 1
      route, route_name = the_route
      train.set_route(route)
      puts "Поезду '#{train.number}' назначен маршрут '#{route_name}'!"
      modification
    when 2
      if train.route
        train.forward
      else
        no_route
      end
      modification
    when 3
      if train.route
        train.backward
      else
        no_route
      end
      modification
    when 4
      puts "Тип поезда #{train.type}"
      car = the_car(train.type)
      train.attach_car(car)
      puts "К поезду '#{train.number}' прицеплен вагон '#{car.number}' производства компании '#{car.manufacturer}'!"
      train_cars(train)
      modification
    when 5
      puts "Выберите вагон:"
      train.cars.each.with_index(1) { |car, index| puts "вагон номер '#{car.number}' - #{index}" }
      cancel_choice
      limit = train.cars.length
      car_number =  gets.chomp.to_i
      check_choice(car_number, limit, :modification)
      car = train.cars[car_number - 1]
      train.detach_car(car)
      puts "От поезда '#{train.number}' отцеплен вагон '#{car.number}'!"
      train_cars(train)
      modification
    when 0
      main
    else
      puts "Введите цифру от 0 до 5"
      modification
    end
  end

  def car_modification
    car = the_car
    if car.type == CAR_TYPES[1]
      puts "Занять место - 1  Освободить место - 2"
      cancel_choice
      user_choice = gets.chomp.to_i
      case user_choice
      when 1
        car.load
        puts "Место занято!"
        car_seats(car)
        car_modification
      when 2
        car.unload
        puts "Место освобождено!"
        car_seats(car)
        car_modification
      when 0
        modification
      else
        puts "Введите цифру от 0 до 2"
        car_modification
      end
    else
      puts "Загрузить вагон - 1  Разгрузить вагон - 2"
      cancel_choice
      user_choice = gets.chomp.to_i
      case user_choice
      when 1
        puts "Введите объем груза для загрузки (в куб.м.)"
        volume = gets.chomp.to_f
        car.load(volume)
        puts "Загружено #{volume} куб.м.!"
        car_volume(car)
        car_modification
      when 2
        puts "Введите объем груза для разрузки (в куб.м.)"
        volume = gets.chomp.to_f
        car.unload(volume)
        puts "Выгружено #{volume} куб.м.!"
        car_volume(car)
        car_modification
      when 0
        modification
      else
        puts "Введите цифру от 0 до 2"
        car_modification
      end
    end
  rescue RuntimeError => e
    puts e.message
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
    case type
    when TRAIN_TYPES[0]
      Car.cargo_car_list.each.with_index(1) { |car, index| puts "#{car.type} вагон номер '#{car.number}' - #{index}" }
      car_choice
      limit = Car.cargo_car_list.length
      car_number = gets.chomp.to_i
      check_choice(car_number, limit, :modification)
      Car.cargo_car_list[car_number - 1]
    when TRAIN_TYPES[1]
      Car.passenger_car_list.each.with_index(1) { |car, index| puts "#{car.type} вагон номер '#{car.number}' - #{index}" }
      car_choice
      limit = Car.passenger_car_list.length
      car_number = gets.chomp.to_i
      check_choice(car_number, limit, :modification)
      Car.passenger_car_list[car_number - 1]
    else
      Car.all.each.with_index(1) { |car, index| puts "#{car.type} вагон номер #{car.number} - #{index}" }
      car_choice
      limit = Car.all.length
      car_number = gets.chomp.to_i
      check_choice(car_number, limit, :modification)
      Car.all[car_number - 1]
    end
  end

  def station_choice
    Station.all.each.with_index(1) { |station, index| puts "#{station.name} - #{index}" }
    cancel_choice
    puts "(Если станции нет в списке, то сначала нужно ее создать)"
  end

  def route_choice
    puts "Выберите маршрут:"
    Route.all.each.with_index(1) { |route, index| puts "маршрут '#{route.departure.name}-#{route.terminal.name}' - #{index}" }
    cancel_choice
    puts "(Если маршрута нет в списке, то сначала нужно его создать)"
  end

  def train_choice
    puts "Выберите поезд из списка:"
    Train.all.each.with_index(1) { |train, index| puts "#{train.type} поезд номер #{train.number} - #{index}" }
    cancel_choice
    puts "(Если поезда с нужным номером нет в списке, то сначала его нужно создать)"
  end

  def car_choice
    cancel_choice
    puts "(Если вагона с нужным номером нет в списке, то сначала его нужно создать)"
  end

  def cancel_choice
    puts "[Отмена - 0]"
  end

  def check_choice(number, limit, menu_cancel, menu_limit = menu_cancel)
    send(menu_cancel) if number == 0
    if number > limit
      no_number
      send(menu_limit)
    end
  end

  def route_stations(route)
    puts "Маршрут '#{route.departure.name}-#{route.terminal.name}'. Станции маршрута:"
    route.stations_list.each { |station| puts station.name }
  end

  def station_trains(station)
    if station.trains.length == 0
      puts "На станции #{station.name}' нет поездов"
    else
      puts "На станции #{station.name}' находятся поезда:"
      station.trains_do do |train|
        puts "   Поезд номер '#{train.number}', тип '#{train.type}', количество вагонов: #{train.cars_count}"
      end
    end
  end

  def train_cars(train)
    if train.cars.length == 0
      puts "У поезда '#{train.number}' производства компании '#{train.manufacturer}' нет вагонов"
    else
      puts "Поезд '#{train.number}' производства компании '#{train.manufacturer}'. Вагоны поезда:"
      if train.type == TRAIN_TYPES[0]
        train.cars_do do |car|
          puts "   Вагон номер '#{car.number}', тип '#{car.type}', "\
               "свободно #{car.available_volume} куб.м., занято #{car.occupied_volume} куб.м."
        end
      else
        train.cars_do do |car|
          puts "Вагон номер '#{car.number}', тип '#{car.type}', "\
               "свободно мест: #{car.available_seats}, занято мест: #{car.occupied_seats}"
        end
      end
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
end
