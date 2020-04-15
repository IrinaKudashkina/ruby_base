require_relative 'car'
require_relative 'validity'

class CargoCar < Car
  include Validity

  attr_reader :volume, :occupied_volume

  def initialize(number, volume)
    @number = number.to_s
    @type = CAR_TYPES[0]
    @volume = volume.to_f
    @occupied_volume = 0
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
