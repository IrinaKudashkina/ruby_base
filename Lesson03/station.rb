require_relative 'instance_counter'
require_relative 'validity'

NAME_FORMAT = /^\p{L}+(\p{L}|\d|-| )*$/

class Station
  include InstanceCounter
  include Validity

  attr_reader :name
  attr_accessor :trains
  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name.to_s.capitalize
    @trains = []
    validate!
    @@stations << self
    register_instance
  end

  def take_train(train)
    self.trains << train
  end

  def send_train(train)
    self.trains.delete(train)
  end

  def trains_list(type = nil)
    if type
      self.trains.select { |train| train.type == type }
    else
      self.trains
    end
  end

  def trains_count(type = 0)
    trains_list(type).length
  end

  private
  def validate!
    raise "Невозможно создать станцию: не указано название станции!" if name.nil?
    raise "Невозможно создать станцию: слишком длинное название!" if name.length > 30
    raise "Невозможно создать станцию: неправильный формат названия!" if name !~ NAME_FORMAT
  end
end
