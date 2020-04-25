require_relative "train"
require_relative "instance_counter"
require_relative "validation"
require_relative "accessors"

class PassengerTrain < Train
  include InstanceCounter
  include Validation

  strong_attr_accessor :conductors, Array

  validate :number, :presence
  validate :number, :format, TRAIN_NUMBER
  validate :chief, :type, String

  def initialize(number, options = {})
    @number = number.to_s
    @type = TRAIN_TYPES[1]
    @speed = (options[:speed] || 0).to_f
    @cars = options[:cars] || []
    @chief = options[:chief] || "Неизвестно"
    @date_of_repair = options[:date_of_repair] || "Неизвестно"
    @conductors = options[:conductors] || []
    validate!
    @@trains[number] = self
    register_instance
  end
end
