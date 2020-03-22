class Route
  attr_reader :departure, :terminal
  attr_accessor :intermediates

  def initialize(departure, *intermediates, terminal)
    @departure = departure
    @terminal = terminal
    @intermediates = intermediates || []
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
end
