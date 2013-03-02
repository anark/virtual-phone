require 'spec_helper'

describe TwilioAdapter do
  let(:adapter) { TwilioAdapter.new }

  describe "#forward_call" do
    let(:number) { FactoryGirl.create(:number) }
    let(:from_number) { "6049999999" }
    let(:xml_response) { Nokogiri::XML adapter.forward_call(number, from_number) }
    subject { xml_response }

    it "should have an array of actions to take" do
      xml_response.root.name.should == "Response"
    end

    describe "transfer action" do
      let(:actions) { xml_response.root.children }
      let(:transfer_action) { actions.first }

      it "should have a caller id set" do
        transfer_action.name.should == "Dial"
        transfer_action["callerId"].should == "6049999999"
      end

      it "should have the number to forward to" do
        transfer_action.children.first.name.should == "Number"
        transfer_action.children.first.text.should ==  number.forward_to
      end
    end
  end

  describe "#forward_sms" do
    let(:number) { FactoryGirl.create(:number) }
    let(:from_number) { "6049999999" }
    let(:message_content) { "hello" }
    let(:xml_response) { Nokogiri::XML adapter.forward_sms(number, from_number, message_content) }
    subject { xml_response }

    it "should have an array of actions to take" do
      xml_response.root.name.should == "Response"
    end

    describe "transfer action" do
      let(:actions) { xml_response.root.children }
      let(:transfer_action) { actions.first }

      it "should have a caller id set" do
        transfer_action.name.should == "Sms"
        transfer_action["from"].should == "6049999999"
      end

      it "should have the number to forward to" do
        transfer_action["to"].should == number.forward_to
      end

      it "should include the message content" do
        transfer_action.children.text.should == message_content
      end
    end
  end

  describe "release_number" do
    let(:number) { FactoryGirl.create(:number, :adapter_identifier => "123") }

    it "should make a delete request to /Accounts/#{ENV['TWILIO_ACCOUNT_SID']}/IncomingPhoneNumbers/123" do
      TwilioAdapter::Http.should_receive(:delete).
        with("/Accounts/#{ENV['TWILIO_ACCOUNT_SID']}/IncomingPhoneNumbers/123").
        and_return(stub(:code => 204))
      adapter.release_number(number)
    end

    it "should raise a NumberNotReleased error if number fails to release" do
      TwilioAdapter::Http.should_receive(:delete).
        and_return(stub(:code => 400))
      lambda { adapter.release_number(number) }.should raise_error(Adapter::NumberNotReleased)
    end
  end

  describe "#provision_number" do
    describe "possible outcomes" do
      let(:response_body) { nil }
      let(:twilio_response) { {"TwilioResponse" => {"IncomingPhoneNumber" => {"PhoneNumber" => "+16049999999", "Sid" => "1234"}}} }
      before do
        TwilioAdapter::Http.should_receive(:post).
          and_return(stub(:code => response_code, :parsed_response => twilio_response))
      end

      context "when provisioning is successful" do
        let(:response_code) { 201 }
        it "should return the number and sid pair" do
          adapter.provision_number("604").should == ["6049999999", "1234"]
        end
      end

      context "when number fails to provision" do
        let(:response_code) { 500 }
        it "should raise an error if provisioning fails" do
          lambda { adapter.provision_number("604") }.should raise_error(Adapter::NumberProvisioningError)
        end
      end

      context "when no number is available" do
        let(:response_code) { 400 }
        it "should raise an error if no number is available" do
          lambda { adapter.provision_number("604") }.should raise_error(Adapter::NumberNotAvailableError)
        end
      end
    end
  end
end
