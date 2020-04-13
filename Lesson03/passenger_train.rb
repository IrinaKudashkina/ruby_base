require_relative 'train'
require_relative 'instance_counter'
require_relative 'validity'

class PassengerTrain < Train
  include InstanceCounter
  include Validity

  def initialize(number, speed = 0)
    @number = number.to_s
    @type = TRAIN_TYPES[1]
    @cars = []
    @speed = speed.to_f
    validate!
    @@trains[number] = self
    register_instance
  end
end
