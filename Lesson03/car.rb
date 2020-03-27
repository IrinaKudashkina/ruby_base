CAR_TYPES = ["грузовой", "пассажирский"]

class Car
  attr_reader :number, :type
  @@cars = []

  def self.all
    @@cars
  end

  def initialize(number, type)
    @number = number.to_s
    @type = type
    @@cars << self
  end

  def self.cargo_car_list
    @@cars.select { |car| car.type == CAR_TYPES[0] }
  end

  def self.passenger_car_list
    @@cars.select { |car| car.type == CAR_TYPES[1] }
  end
end
