class CargoCar < Car
  def initialize(number)
    @number = number.to_s
    @type = CAR_TYPES[0]
    @@cars << self
  end
end
