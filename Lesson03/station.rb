require_relative "instance_counter"
require_relative "validity"

class Station
  include InstanceCounter
  include Validity

  NAME_FORMAT = /^\p{L}+(\p{L}|\d|-| )*$/.freeze

  attr_reader :name
  attr_accessor :trains
  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name, options = {})
    @name = name.to_s.capitalize
    @trains = options[:trains] || []
    validate!
    @@stations << self
    register_instance
  end

  def take_train(train)
    trains << train
  end

  def send_train(train)
    trains.delete(train)
  end

  def trains_list(type = nil)
    if type
      trains.select { |train| train.type == type }
    else
      trains
    end
  end

  def trains_count(type = 0)
    trains_list(type).length
  end

  def trains_do
    trains.each { |train| yield train }
  end

  private

  def validate!
    raise "Невозможно создать станцию: не указано название станции!" if name.nil?
    raise "Невозможно создать станцию: слишком длинное название!" if name.length > 30
    raise "Невозможно создать станцию: неправильный формат названия!" if name !~ NAME_FORMAT
  end
end
