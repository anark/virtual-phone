require 'spec_helper'

describe Number do
  describe "validations" do
    subject { Factory(:number) }
    it { should validate_presence_of :number }
    it { should validate_uniqueness_of(:number) }
    it { should allow_value("6049999999").for(:number) }
    it { should_not allow_value("16049999999").for(:number) }
    it { should_not allow_value("604-999-9999").for(:number) }
  end

  describe "associations" do
    it { should belong_to :phone }
  end

  describe '#find_by_number' do
    let!(:number) { Factory(:number, :number => "6049999999") }

    it 'should find number without country code' do
      Number.find_by_number('6049999999').should == number
    end

    it 'should find number with country code' do
       Number.find_by_number('16049999999').should == number
    end
  end

  describe "forward_to" do
    let(:number) { Factory(:number) }
    subject {number}

    its(:forward_to) { should == number.phone.number }
  end

  describe "provision_number callback" do
    let(:number) { Factory.build(:number, :number => nil, :prefix => '604') }

    it "should call provision number on create if number has a prefix and no number" do
      number.should_receive(:provision_number)
      number.save
    end

    it "should not call provision number on create if number has a number" do
      number.number = '6049991234'
      number.should_not_receive(:provision_number)
      number.save
    end
  end

  describe "provision number" do
    let(:number) { Factory.build(:number, :number => nil, :prefix => '604') }

    it "should set the number to the provisioned number on create" do
      adapter = Adapter.new
      adapter.stub :provision_number => "6048001234"
      number.should_receive(:adapter).any_number_of_times.and_return(adapter)
      number.save
      number.number.should == "6048001234"
    end
  end
end
