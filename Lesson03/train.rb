TRAIN_TYPES = ["грузовой", "пассажирский"]

class Train
  attr_reader :number, :type
  attr_accessor :cars, :speed, :route, :station
  @@trains = []

  def self.all
    @@trains
  end

  def initialize(number, type, speed = 0)
    @number = number.to_s
    @type = type
    @cars = []
    @speed = speed
    @@trains << self
  end

  def stop
    self.speed = 0
  end

  def attach_car(car)
    self.cars << car if self.speed == 0 && car.type == self.type
  end

  def detach_car(car)
    self.cars.delete(car) if self.speed == 0 && cars_count >= 1
  end

  def cars_count
    self.cars.length
  end

  def set_route(route)
    self.route = route
    self.station = route.departure
    route.departure.take_train(self)
  end

  def stations_list
    self.route.stations_list
  end

  def previous_station
    self.stations_list[self.station_index - 1] unless first_station?
  end

  def next_station
    self.stations_list[self.station_index + 1] unless last_station?
  end

  def forward
    unless last_station?
      self.station.send_train(self)
      self.station = self.next_station
      self.station.take_train(self)
      puts "Поезд прибыл на станцию '#{self.station.name}'"
      self.station
    end
  end

  def backward
    unless first_station?
      self.station.send_train(self)
      self.station = self.previous_station
      self.station.take_train(self)
      puts "Поезд прибыл на станцию '#{self.station.name}'"
      self.station
    end
  end

  protected
# вспомогательные методы, которые используются только внутри этого класса и его потомков

  def station_index
    self.stations_list.find_index(self.station)
  end

  def first_station?
    self.station == self.route.departure if self.route
  end

  def last_station?
    self.station == self.route.terminal if self.route
  end
end
