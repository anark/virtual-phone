require 'spec_helper'

describe TropoAdapter do
  let(:adapter) { TropoAdapter.new }

  describe "#forward_call" do
    let(:number) { FactoryGirl.create(:number) }
    let(:from_number) { "6049999999" }
    let(:json_response) { JSON.parse adapter.forward_call(number, from_number).to_json }
    subject { json_response }

    it "should have an array of actions to take" do
      json_response["tropo"].should be_instance_of(Array)
    end

    describe "transfer action" do
      let(:actions) { json_response["tropo"].first }
      let(:transfer_action) { actions.first }
      let(:transfer_action_options) { transfer_action.second }

      it "should have a transfer block" do
        transfer_action.first.should == "transfer"
      end

      it "should have a from option set to the caller id" do
        transfer_action_options["from"].should == from_number
      end

      it "should have a to number set to the receiving numbers forward to" do
        transfer_action_options["to"].should == number.forward_to
      end
    end
  end

  describe "release_number" do
    let(:number) { FactoryGirl.create(:number, :adapter_identifier => "+16043333333") }

    it "should make a delete request to /addresses/number/+16043333333" do
      TropoAdapter::Http.should_receive(:delete).
        with("/addresses/number/+16043333333").
        and_return(stub(:code => 200))
      adapter.release_number(number)
    end

    it "should raise a NumberNotReleased error if number fails to release" do
      TropoAdapter::Http.should_receive(:delete).
        and_return(stub(:code => 400))
      lambda { adapter.release_number(number) }.should raise_error(Adapter::NumberNotReleased)
    end
  end

  describe "provision_number" do
    let(:response_data) { stub(:code => 200, :body => {"href" => "+16041111111"}.to_json) }

    it "should post to /addresses" do
      TropoAdapter::Http.should_receive(:post).
        with("/addresses", anything()).
        and_return(response_data)
      adapter.provision_number("604")
    end

    it "should request type number" do
      TropoAdapter::Http.should_receive(:post).
        with(anything(), hash_including(:body => hash_including(:type => "number"))).
        and_return(response_data)
      adapter.provision_number("604")
    end

    it "should request the supplied prefix with country code" do
      TropoAdapter::Http.should_receive(:post).
        with(anything(), hash_including(:body => hash_including(:prefix => "1604"))).
        and_return(response_data)
      adapter.provision_number("604")
    end

    describe "possible outcomes" do
      let(:response_body) { nil }
      before do
        TropoAdapter::Http.should_receive(:post).
          and_return(stub(:code => response_code, :body => response_body.to_json))
      end

      context "when provisioning is successful" do
        let(:response_code) { 200 }
        let(:response_body) { {"href" => "http://trop.com/addresses/number/+16049999999"} }
        it "should return the number and adapter_identifier pair" do
          provisioning_response = adapter.provision_number("604")
          provisioning_response.number.should == "6049999999"
          provisioning_response.adapter_identifier.should == "+16049999999"
        end
      end

      context "when no number is available" do
        let(:response_code) { 503 }
        it "should raise an error if the prefix is not available" do
          lambda { adapter.provision_number("604") }.should raise_error(Adapter::NumberNotAvailableError)
        end
      end

      context "when number fails to provision" do
        let(:response_code) { 500 }
        it "should raise an error if provisioning fails" do
          lambda { adapter.provision_number("604") }.should raise_error(Adapter::NumberProvisioningError)
        end
      end
    end
  end
end
