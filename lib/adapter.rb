class Adapter
  attr_accessor :request_params

  def initialize(request_params=nil)
    @request_params = request_params
  end

  def release_number(number)
    raise NotImplementedError, "release_number is not defined for #{self}"
  end
end

class Adapter::NumberNotReleased < StandardError
end

class Adapter::NumberProvisioningError < StandardError
end

class Adapter::NumberNotAvailableError < StandardError
end
