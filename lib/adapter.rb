class Adapter
  attr_accessor :request_params

  def initialize(request_params=nil)
    @request_params = request_params
  end

  def release_number(number)
    raise NotImplementedError, "release_number is not defined for #{self}"
  end

  def process_provisioning_response(provisioning_response)
    if provisioning_response.success?
      number = provisioning_response.number
      adapter_identifier = provisioning_response.adapter_identifier
      return [number, adapter_identifier]
    elsif provisioning_response.number_not_available?
      raise NumberNotAvailableError, provisioning_response.response.inspect
    else
      raise NumberProvisioningError, provisioning_response.response.inspect
    end
  end
end

class Adapter::NumberNotReleased < StandardError
end

class Adapter::NumberProvisioningError < StandardError
end

class Adapter::NumberNotAvailableError < StandardError
end

