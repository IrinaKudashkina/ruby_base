require_relative 'instance_counter'

class Station
  include InstanceCounter

  attr_reader :name
  attr_accessor :trains
  @@stations = []

  def self.all
    @@stations
  end

  def initialize(name)
    @name = name
    @trains = []
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
end
