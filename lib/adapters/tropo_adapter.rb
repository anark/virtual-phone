class TropoAdapter < Adapter
  class Http
    include HTTParty

    base_uri "https://api.tropo.com/v1/applications/#{ENV['TROPO_APPLICATION_ID']}"
    basic_auth(ENV['TROPO_USERNAME'], ENV['TROPO_PASSWORD'])
    headers 'Content-type' => 'application/json'
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
    response = Http.post("/addresses", :body => options.to_json)
    case response.code
    when 200
      return JSON.parse(response.body)["href"].split("+1").last
    when 503
      raise NumberNotAvailableError
    else
      raise NumberProvisioningError
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
