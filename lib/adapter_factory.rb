class AdapterFactory
  def self.create(request_params)
    if request_params.include? "CallSid"
      TwilioAdapter.new(request_params)
    else
      TropoAdapter.new(request_params)
    end
  end
end
