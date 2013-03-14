class TropoAdapter < Adapter
  class Http
    include HTTParty

    base_uri "https://api.tropo.com/v1/applications/#{ENV['TROPO_APPLICATION_ID']}"
    basic_auth(ENV['TROPO_USERNAME'], ENV['TROPO_PASSWORD'])
    headers 'ContentType' => 'application/json'
  end

  class ProvisioningResponse
    attr_accessor :response

    def initialize(response)
      @response = response
    end

    def success?
      @response.code == 200
    end

    def adapter_identifier
      JSON.parse(@response.body)["href"].split("/number/").last
    end

    def number
      adapter_identifier.split("+1").last
    end

    def number_not_available?
      @response.code == 503
    end
  end

  def to
    params[:to][:id]
  end

  def from
    params[:from][:id]
  end

  def message_content
    params[:initial_text]
  end

  def response_type
    :json
  end

  def forward_call(number, from_number)
    tropo = Tropo::Generator.new
    tropo.transfer(
      :to => number.forward_to,
      :from => from_number
    )
    tropo
  end

  def provision_number(prefix)
    prefix = "1#{prefix}"
    options = { :type => "number", :prefix => prefix }
    response = Http.post("/addresses", :body => options)
    process_provisioning_response ProvisioningResponse.new(response)
  end

  def release_number(number)
    response = Http.delete("/addresses/number/#{number.adapter_identifier}")
    unless response.code == 200
      raise NumberNotReleased, response.inspect
    end
  end

  def forward_sms(number, from_number, message)
    tropo = Tropo::Generator.new
    tropo.message({
      :to => number.forward_to,
      :from => from_number,
      :network => "SMS" }) do
        say :value => message
      end
    tropo
  end

  protected

  def params
    request_params[:session]
  end
end
