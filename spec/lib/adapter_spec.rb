require 'spec_helper'

describe Adapter do
  let(:request_params) { nil }
  let(:adapter) { Adapter.new(request_params) }
  subject { adapter }

  its(:request_params) { should == nil }

  context "with a given request" do
    let(:request_params) { "test_request" }
    its(:request_params) { should == "test_request" }
  end
end
