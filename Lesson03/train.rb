require_relative 'manufacturer'
require_relative 'instance_counter'

TRAIN_TYPES = ["грузовой", "пассажирский"]
TRAIN_NUMBER = /^(\p{L}|\d){3}-?(\p{L}|\d){2}$/

class Train
  include Manufacturer
  include InstanceCounter

  attr_reader :number, :type
  attr_accessor :cars, :speed, :route, :station
  @@trains = {}

  def self.all
    @@trains.values
  end

  def self.find(number)
    @@trains[number]
  end

  def initialize(number, type, speed = 0)
    @number = number.to_s
    @type = type
    @cars = []
    @speed = speed.to_f
    validate!
    @@trains[number] = self
    register_instance
  end

  def valid?
    validate!
    true
  rescue
    false
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

  def validate!
    raise "Невозможно создать поезд: не указан номер поезда!" if number.nil?
    raise "Невозможно создать поезд: не указан тип поезда!" if type.nil?
    raise "Невозможно создать поезд: неправильный формат номера поезда!" if number !~ TRAIN_NUMBER
    raise "Невозможно создать поезд: неправильный тип поезда!" unless TRAIN_TYPES.include?(type)
  end

  def station_index
    stations_list.find_index(station)
  end

  def first_station?
    station == route.departure if route
  end

  def last_station?
    station == route.terminal if route
  end
end
