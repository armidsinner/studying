# Type for a vagon
class CargoVagon < Vagon
  attr_reader :used_volume, :volume
  def initialize(volume)
    @volume = volume
    @used_volume = 0
    @type = 'freight'
  end

  def use_volume(space)
    @used_volume += space
  end

  def free_volume
    @volume - @used_volume
  end
end

