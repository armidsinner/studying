# Type for a vagon
class PassengerVagon < Vagon
  attr_reader :sits, :used_sits
  def initialize(sits)
    @sits = sits
    @used_sits = 0
    @type = 'passenger'
  end

  def take_a_sit
    @used_sits += 1
  end

  def free_sits 
    @sits - @used_sits
  end
end
