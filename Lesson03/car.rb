require_relative "manufacturer"
require_relative "validation"
require_relative "accessors"

class Car
  extend Accessors
  include Manufacturer
  include Validation

  CAR_TYPES = %w[грузовой пассажирский].freeze
  CAR_NUMBER = /^(\p{L}|\d){5,10}$/.freeze

  attr_reader :number, :type
  attr_accessor_with_history :date_of_repair
  strong_attr_accessor :color, String
  @@cars = []

  validate :number, :presence
  validate :type, :presence
  validate :number, :format, CAR_NUMBER

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

  def initialize(number, type, options = {})
    @number = number.to_s
    @type = type
    @color = options[:color] || "Неизвестно"
    @date_of_repair = options[:date_of_repair] || "Неизвестно"
    validate!
    @@cars << self
  end
end
