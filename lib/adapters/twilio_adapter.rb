class TwilioAdapter < Adapter
  class Http
    include HTTParty

    base_uri "https://api.twilio.com/2010-04-01"
    basic_auth(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
  end

  class ProvisioningResponse
    attr_accessor :response

    def initialize(response)
      @response = response
    end

    def success?
      @response.code == 201
    end

    def parsed_response
      @response.parsed_response
    end

    def phone_number_attributes
      parsed_response["TwilioResponse"]["IncomingPhoneNumber"]
    end

    def number
      phone_number_attributes["PhoneNumber"].split("+1").last
    end

    def adapter_identifier
      phone_number_attributes["Sid"]
    end

    def number_not_available?
      begin
        parsed_response["TwilioResponse"]["RestException"]["Code"] == "21452"
      rescue NoMethodError
        false
      end
    end
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
    process_provisioning_response ProvisioningResponse.new(response)
  end

  def release_number(number)
    response = Http.delete("/Accounts/#{ENV['TWILIO_ACCOUNT_SID']}/IncomingPhoneNumbers/#{number.adapter_identifier}")
    unless response.code == 204
      raise NumberNotReleased, response.inspect
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
