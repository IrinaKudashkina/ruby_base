require_relative "train"
require_relative "instance_counter"
require_relative "validation"
require_relative "accessors"

class CargoTrain < Train
  include InstanceCounter
  include Validation

  validate :number, :presence
  validate :number, :format, TRAIN_NUMBER
  validate :chief, :type, String

  def initialize(number, options = {})
    @number = number.to_s
    @type = TRAIN_TYPES[0]
    @speed = (options[:speed] || 0).to_f
    @cars = options[:cars] || []
    @chief = options[:chief] || "Неизвестно"
    @date_of_repair = options[:date_of_repair] || "Неизвестно"
    validate!
    @@trains[number] = self
    register_instance
  end
end
