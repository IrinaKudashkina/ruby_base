require_relative "car"
require_relative "validation"
require_relative "accessors"

class PassengerCar < Car
  include Validation

  attr_reader :seats, :occupied_seats

  validate :number, :presence
  validate :number, :format, CAR_NUMBER
  validate :seats, :type, Integer

  def initialize(number, seats, options = {})
    @number = number.to_s
    @type = CAR_TYPES[1]
    @seats = seats.to_i
    @occupied_seats = 0
    @color = options[:color] || "Неизвестно"
    @date_of_repair = options[:date_of_repair] || "Неизвестно"
    validate!
    @@cars << self
  end

  def load
    raise "Недостаточно свободных мест для посадки!" unless occupied_seats < seats

    self.occupied_seats += 1
  end

  def unload
    raise "Невозможно освободить место: в вагоне нет занятых мест!" if occupied_seats < 1

    self.occupied_seats -= 1
  end

  def available_seats
    seats - occupied_seats
  end

  private

  attr_writer :occupied_seats
end
