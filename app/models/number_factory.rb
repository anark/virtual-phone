class NumberFactory
  def self.build_number(params)
    adapter_class.new(params)
  end

  def self.adapter_class
    case ENV['ADAPTER']
    when 'tropo'
      TropoNumber
    when 'twilio'
      TwilioNumber
    else
      MockNumber
    end
  end
end
