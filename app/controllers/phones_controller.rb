class PhonesController < ApplicationController
  def incoming_call
    adapter = AdapterFactory.create(params)
    number = Number.find_by_number adapter.to
    render adapter.response_type => number.incoming_call(adapter.from)
  end

  def incoming_sms
    adapter = AdapterFactory.create(params)
    number = Number.find_by_number adapter.to
    render adapter.response_type => number.incoming_sms(adapter.from, adapter.message_content)
  end
end
