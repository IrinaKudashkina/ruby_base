class PassengerCar < Car
  def initialize(number)
    @number = number.to_s
    @type = CAR_TYPES[1]
    validate!
    @@cars << self
  end
end
