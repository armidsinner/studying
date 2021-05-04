require_relative 'modules'
# vagon
class Vagon
  include SetBrand
  include Accessor
  include Validation
  attr_accessor :type
  def initialize
    @type = type
  end
end

