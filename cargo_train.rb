# Train with freight vagons only
class CargoTrain < Train
  attr_reader :type
  def initialize(number)
    super
    @type = 'freight'
  end
end
