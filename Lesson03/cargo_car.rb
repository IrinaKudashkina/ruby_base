require_relative "car"
require_relative "validation"
require_relative "accessors"

class CargoCar < Car
  include Validation

  attr_reader :volume, :occupied_volume

  validate :number, :presence
  validate :number, :format, CAR_NUMBER
  validate :volume, :type, Float

  def initialize(number, volume, options = {})
    @number = number.to_s
    @type = CAR_TYPES[0]
    @volume = volume.to_f
    @occupied_volume = 0
    @color = options[:color] || "Неизвестно"
    @date_of_repair = options[:date_of_repair] || "Неизвестно"
    validate!
    @@cars << self
  end

  def load(cargo_volume)
    raise "Недостаточно свободного объема для загрузки!" if occupied_volume + cargo_volume > volume

    self.occupied_volume += cargo_volume
  end

  def unload(cargo_volume)
    raise "Введенный объем груза больше доступного к выгрузке!" if cargo_volume > occupied_volume

    self.occupied_volume -= cargo_volume
  end

  def available_volume
    volume - occupied_volume
  end

  private

  attr_writer :occupied_volume
end
