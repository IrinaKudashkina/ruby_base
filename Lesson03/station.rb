require_relative "instance_counter"
require_relative "validation"
require_relative "accessors"

class Station
  extend Accessors
  include InstanceCounter
  include Validation

  NAME_FORMAT = /^\p{L}+(\p{L}|\d|-| )*$/.freeze

  attr_reader :name
  attr_accessor :trains
  attr_accessor_with_history :chief
  strong_attr_accessor :region, String
  @@stations = []

  validate :name, :presence
  validate :name, :format, NAME_FORMAT
  validate :chief, :type, String

  def self.all
    @@stations
  end

  def initialize(name, options = {})
    @name = name.to_s.capitalize
    @trains = options[:trains] || []
    @chief = options[:chief] || "Неизвестно"
    @region = options[:region] || "Неизвестно"
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
end
