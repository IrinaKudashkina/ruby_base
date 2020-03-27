class CargoTrain < Train
  def initialize(number, speed = 0)
    @number = number.to_s
    @type = TRAIN_TYPES[0]
    @cars = []
    @speed = speed
    @@trains << self
  end
end
