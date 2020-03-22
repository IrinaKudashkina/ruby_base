TRAIN_TYPES = ["грузовой", "пассажирский"]

class Train
  attr_reader :number, :type
  attr_accessor :cars_count, :speed, :route, :station

  def initialize(number, type, cars_count, speed = 0)
    @number = number
    @type = type
    @cars_count = cars_count
    @speed = speed
  end

  def stop
    self.speed = 0
  end

  def attach_car
    self.cars_count += 1 if self.speed == 0
  end

  def detach_car
    self.cars_count -= 1 if self.speed == 0 && self.cars_count >= 1
  end

  def set_route(route)
    self.route = route
    self.station = route.departure
    route.departure.take_train(self)
  end

  def stations_list
    self.route.stations_list
  end

  def station_index
    self.stations_list.find_index(self.station)
  end

  def first_station?
    self.station == self.route.departure
  end

  def last_station?
    self.station == self.route.terminal
  end

  def previous_station
    self.stations_list[self.station_index - 1] unless first_station?
  end

  def next_station
    self.stations_list[self.station_index + 1] unless last_station?
  end

  def forward
    unless last_station?
      self.station.send_train(self)
      self.station = self.next_station
      self.station.take_train(self)
      puts "чу-чух чу-чух #{self.station.name}"
      self.station
    end
  end

  def backward
    unless first_station?
      self.station.send_train(self)
      self.station = self.previous_station
      self.station.take_train(self)
      self.station
    end
  end
end
