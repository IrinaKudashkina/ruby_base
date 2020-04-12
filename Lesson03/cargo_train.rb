require_relative 'instance_counter'

class CargoTrain < Train
  include InstanceCounter

  def initialize(number, speed = 0)
    @number = number.to_s
    @type = TRAIN_TYPES[0]
    @cars = []
    @speed = speed.to_f
    validate!
    @@trains[number] = self
    register_instance
  end
end
