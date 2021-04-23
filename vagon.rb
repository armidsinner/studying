require_relative 'modules'
# vagon
class Vagon
  include SetBrand
  attr_accessor :type
  def initialize
    @type = type
  end
end
