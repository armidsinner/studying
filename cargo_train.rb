# Train with freight vagons only
class CargoTrain < Train
  def initialize(number)
    super
    @type = 'freight'
  end
end
