require_relative 'manufacturer'

CAR_TYPES = ["грузовой", "пассажирский"]
CAR_NUMBER = /^(\p{L}|\d){5,10}$/

class Car
  include Manufacturer

  attr_reader :number, :type
  @@cars = []

  def self.all
    @@cars
  end

  def initialize(number, type)
    @number = number.to_s
    @type = type
    validate!
    @@cars << self
  end

  def valid?
    validate!
    true
  rescue
    false
  end

  def self.cargo_car_list
    @@cars.select { |car| car.type == CAR_TYPES[0] }
  end

  def self.passenger_car_list
    @@cars.select { |car| car.type == CAR_TYPES[1] }
  end

  protected

  def validate!
    raise "Невозможно создать вагон: не указан номер вагона!" if number.nil?
    raise "Невозможно создать вагон: не указан тип вагона!" if type.nil?
    raise "Невозможно создать вагон: неправильный формат номера вагона!" if number !~ CAR_NUMBER
    raise "Невозможно создать вагон: неправильный тип вагона!" unless CAR_TYPES.include?(type)
  end
end
