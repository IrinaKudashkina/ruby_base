class PassengerCar < Car
  def initialize(number)
    @number = number.to_s
    @type = CAR_TYPES[1]
    @@cars << self
  end
end
