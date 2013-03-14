class MockAdapter < Adapter
  class ProvisioningResponse
    attr_accessor :prefix

    def initialize(prefix)
      @prefix = prefix
    end

    def success?
      true
    end

    def number
      Faker::Base.numerify("#{prefix}#######")
    end

    def adapter_identifier
      Random.rand(1024)
    end
  end

  def provision_number(prefix)
    ProvisioningResponse.new(prefix)
  end

  def release_number(number)
    true
  end
end
