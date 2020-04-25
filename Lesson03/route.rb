require_relative "instance_counter"
require_relative "station"
require_relative "validation"
require_relative "accessors"

class Route
  extend Accessors
  include InstanceCounter
  include Validation

  attr_reader :departure, :terminal
  attr_accessor :intermediates
  attr_accessor_with_history :travel_time
  strong_attr_accessor :acronym_name, String
  @@routes = []

  validate :departure, :type, Station
  validate :terminal, :type, Station

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
end
