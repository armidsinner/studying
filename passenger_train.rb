# Train with passenger vagons only 
class PassengerTrain < Train
  attr_reader :type
  def initialize(number)
    super
    @type = 'passenger'
  end
end






