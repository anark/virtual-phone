require 'spec_helper'

describe AdapterFactory do
  let(:request_params) { {} }
  let(:adapter) { AdapterFactory.create(request_params) }
  subject { adapter }

  it { should be_instance_of TropoAdapter }

  context "when params include CallSid" do
    let(:request_params) { {"CallSid" => "1234"} }
    subject { adapter }

    it { should be_instance_of TwilioAdapter }
  end
end
