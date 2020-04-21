require_relative "train"
require_relative "instance_counter"
require_relative "validity"

class PassengerTrain < Train
  include InstanceCounter
  include Validity

  def initialize(number, options = {})
    @number = number.to_s
    @type = TRAIN_TYPES[1]
    @speed = (options[:speed] || 0).to_f
    @cars = options[:cars] || []
    validate!
    @@trains[number] = self
    register_instance
  end
end
