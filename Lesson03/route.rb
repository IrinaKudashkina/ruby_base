require_relative "instance_counter"
require_relative "station"
require_relative "validity"

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
    intermediates << station
  end

  def delete_station(station)
    intermediates.delete(station)
  end

  def stations_list
    [departure, intermediates, terminal].flatten
  end

  private

  def validate!
    message = "Невозможно создать маршрут: станция маршрута не является объектом класса Station!"
    raise message unless departure.is_a?(Station) && terminal.is_a?(Station)

    return if intermediates.empty?

    intermediates.each { |station| raise message unless station.is_a?(Station) }
  end
end
