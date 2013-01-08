class Adapter
  attr_accessor :request_params

  def initialize(request_params=nil)
    @request_params = request_params
  end
end
