require_relative "manufacturer"
require_relative "validity"

class Car
  include Manufacturer
  include Validity

  CAR_TYPES = %w[грузовой пассажирский].freeze
  CAR_NUMBER = /^(\p{L}|\d){5,10}$/.freeze

  attr_reader :number, :type
  @@cars = []

  class << self
    def all
      @@cars
    end

    def cargo_car_list
      @@cars.select { |car| car.type == CAR_TYPES[0] }
    end

    def passenger_car_list
      @@cars.select { |car| car.type == CAR_TYPES[1] }
    end
  end

  def initialize(number, type)
    @number = number.to_s
    @type = type
    validate!
    @@cars << self
  end

  protected

  def validate!
    raise "Невозможно создать вагон: не указан номер вагона!" if number.nil?
    raise "Невозможно создать вагон: не указан тип вагона!" if type.nil?
    raise "Невозможно создать вагон: неправильный формат номера вагона!" if number !~ CAR_NUMBER
    raise "Невозможно создать вагон: неправильный тип вагона!" unless CAR_TYPES.include?(type)
  end
end
