class TwilioAdapter < Adapter
  class Http
    include HTTParty

    base_uri "https://api.twilio.com/2010-04-01"
    basic_auth(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
  end

  def to
    params["To"].gsub(/[^0-9]/, "")# Remove +
  end

  def from
    params["From"]
  end

  def message_content
    params["Body"]
  end

  def response_type
    :xml
  end

  def forward_call(number, from_number)
    response = Twilio::TwiML::Response.new do |r|
      r.Dial :callerId => from_number do |d|
        d.Number number.forward_to
      end
    end
    response.text
  end

  def provision_number(prefix)
    number_options = { "AreaCode" => prefix, "VoiceUrl" => "#{ENV['URL']}/phones/incoming_call", "SmsUrl" => "#{ENV['URL']}/phones/incoming_sms" }
    response = Http.post("/Accounts/#{ENV['TWILIO_ACCOUNT_SID']}/IncomingPhoneNumbers", :body => number_options)
    case response.code
    when 200
      return response.parsed_response["TwilioResponse"]["IncomingPhoneNumber"]["PhoneNumber"].split("+1").last
    else
      raise NumberProvisioningError
    end
  end

  def release_number(number)
    response = Http.delete("/Accounts/#{ENV['TWILIO_ACCOUNT_SID']}/IncomingPhoneNumbers/#{number.sid}")
    unless response.code == 204
      raise NumberNotReleased
    end
  end

  def forward_sms(number, from_number, message)
    response = Twilio::TwiML::Response.new do |r|
      r.Sms message, :to => number.forward_to, :from => from_number
    end
    response.text
  end

  protected

  def params
    request_params
  end
end
