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

  describe "provision_number" do
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
