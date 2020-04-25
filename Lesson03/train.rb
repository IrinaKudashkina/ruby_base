require_relative "manufacturer"
require_relative "instance_counter"
require_relative "validation"
require_relative "accessors"

class Train
  extend Accessors
  include Manufacturer
  include InstanceCounter
  include Validation

  TRAIN_TYPES = %w[грузовой пассажирский].freeze
  TRAIN_NUMBER = /^(\p{L}|\d){3}-?(\p{L}|\d){2}$/.freeze

  attr_reader :number, :type
  attr_accessor :cars, :speed, :route, :station
  attr_accessor_with_history :chief, :date_of_repair
  strong_attr_accessor :year_of_manufacture, Integer
  @@trains = {}

  validate :number, :presence
  validate :type, :presence
  validate :number, :format, TRAIN_NUMBER
  validate :chief, :type, String

  class << self
    def all
      @@trains.values
    end

    def find(number)
      raise "Нет поезда с таким номером!" if @@trains[number].nil?

      @@trains[number]
    end
  end

  def initialize(number, type, options = {})
    @number = number.to_s
    @type = type
    @speed = (options[:speed] || 0).to_f
    @cars = options[:cars] || []
    @chief = options[:chief] || "Неизвестно"
    @date_of_repair = options[:date_of_repair] || "Неизвестно"
    validate!
    @@trains[number] = self
    register_instance
  end

  def stop
    self.speed = 0
  end

  def attach_car(car)
    cars << car if speed.zero? && car.type == type
  end

  def detach_car(car)
    cars.delete(car) if speed.zero? && cars_count >= 1
  end

  def cars_count
    cars.length
  end

  def assign_route(route)
    self.route = route
    self.station = route.departure
    route.departure.take_train(self)
  end

  def stations_list
    route.stations_list
  end

  def previous_station
    stations_list[station_index - 1] unless first_station?
  end

  def next_station
    stations_list[station_index + 1] unless last_station?
  end

  def forward
    return if last_station?

    station.send_train(self)
    self.station = next_station
    station.take_train(self)
    puts "Поезд прибыл на станцию '#{station.name}'"
    station
  end

  def backward
    return if first_station?

    station.send_train(self)
    self.station = previous_station
    station.take_train(self)
    puts "Поезд прибыл на станцию '#{station.name}'"
    station
  end

  def cars_do
    cars.each { |car| yield car }
  end

  protected

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
