class CargoCar < Car
  def initialize(number)
    @number = number.to_s
    @type = CAR_TYPES[0]
    validate!
    @@cars << self
  end
end
