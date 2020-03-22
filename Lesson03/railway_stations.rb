TRAIN_TYPES = ["грузовой", "пассажирский"]

class Station
  attr_reader :name
  attr_accessor :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def take_train(train)
    self.trains << train
  end

  def send_train(train)
    self.trains.delete(train)
  end

  def trains_list(type = 0)
    if type == 0
      self.trains
    else
      one_type = []
      self.trains.each do |train|
        one_type << train if train.type == type
      end
      one_type
    end
  end

  def trains_count(type = 0)
    trains_list(type).length
  end
end

class Route
  attr_reader :departure, :terminal
  attr_accessor :intermediates

  def initialize(departure, *intermediates, terminal)
    @departure = departure
    @terminal = terminal
    @intermediates = intermediates
  end

  def add_station(station)
    self.intermediates << station
  end
  
  def delete_station(station)
    self.intermediates.delete(station)
  end

  def stations_list
    stations = [self.departure]
    self.intermediates.each { |station| stations << station }
    stations << self.terminal
    stations
  end
end

class Train
  attr_reader :number, :type
  attr_accessor :cars_count, :speed, :route, :station

  def initialize(number, type, cars_count, speed = 0)
    @number = number
    @type = type
    @cars_count = cars_count
    @speed = speed
  end

  def stop
    self.speed = 0
  end

  def attach_car
    self.cars_count += 1 if self.speed == 0
  end

  def detach_car
    self.cars_count -= 1 if self.speed == 0
  end

  def set_route(route)
    self.route = route
    self.station = route.departure
    route.departure.take_train(self)
  end

  def stations_list
    self.route.stations_list
  end

  def station_index
    self.stations_list.find_index(self.station)
  end

  def next_station
    self.stations_list[self.station_index + 1]
  end

  def previous_station
    self.stations_list[self.station_index - 1]
  end

  def forward
    self.station.send_train(self)
    self.station = self.next_station
    self.station.take_train(self)
    self.station
  end

  def backward
    self.station.send_train(self)
    self.station = self.previous_station
    self.station.take_train(self)
    self.station
  end
end















