require 'spec_helper'

describe TwilioAdapter do
  let(:adapter) { TwilioAdapter.new }

  describe "#forward_call" do
    let(:number) { Factory(:number) }
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
    let(:number) { Factory(:number) }
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

  describe "#provision_number" do
    it "should provision a new number with the prefix and return the number" do
      pending
    end

    it "should raise an error if the prefix is not available" do
      pending
    end

    it "should raise an error when the number fails to provision" do
      pending
    end
  end
end
