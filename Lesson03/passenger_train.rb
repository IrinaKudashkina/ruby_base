require_relative 'instance_counter'

class PassengerTrain < Train
  include InstanceCounter

  def initialize(number, speed = 0)
    @number = number.to_s
    @type = TRAIN_TYPES[1]
    @cars = []
    @speed = speed
    @@trains[number] = self
    register_instance
  end
end
