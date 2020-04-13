require_relative 'car'
require_relative 'validity'

class PassengerCar < Car
  include Validity

  def initialize(number)
    @number = number.to_s
    @type = CAR_TYPES[1]
    validate!
    @@cars << self
  end
end
