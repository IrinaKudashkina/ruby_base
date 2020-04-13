require_relative 'instance_counter'
require_relative 'station'
require_relative 'validity'

class Route
  include InstanceCounter
  include Validity

  attr_reader :departure, :terminal
  attr_accessor :intermediates
  @@routes = []

  def self.all
    @@routes
  end

  def initialize(departure, *intermediates, terminal)
    @departure = departure
    @terminal = terminal
    @intermediates = intermediates || []
    validate!
    @@routes << self
    register_instance
  end

  def add_station(station)
    self.intermediates << station
  end

  def delete_station(station)
    self.intermediates.delete(station)
  end

  def stations_list
    [self.departure, self.intermediates, self.terminal].flatten
  end

  private

  def validate!
    message = "Невозможно создать маршрут: станция маршрута не является объектом класса Station!"
    unless departure.kind_of?(Station) & terminal.kind_of?(Station)
      raise message
    end
    unless intermediates.empty?
      intermediates.each { |station| raise message unless  station.kind_of?(Station) }
    end
  end
end
