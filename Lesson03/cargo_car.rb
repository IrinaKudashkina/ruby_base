require_relative 'car'
require_relative 'validity'

class CargoCar < Car
  include Validity

  def initialize(number)
    @number = number.to_s
    @type = CAR_TYPES[0]
    validate!
    @@cars << self
  end
end
