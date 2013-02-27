require 'spec_helper'

describe Number do
  describe "validations" do
    subject { FactoryGirl.create(:number) }
    it { should validate_presence_of :number }
    it { should validate_uniqueness_of(:number) }
    it { should allow_value("6049999999").for(:number) }
    it { should_not allow_value("00000").for(:number) }
  end

  describe "associations" do
    it { should belong_to :phone }
  end

  describe "number=" do
    let(:number) { Number.new }
    it "should add the appropriate country code to the number" do
      number.number = "6049999999"
      number.valid?
      number.number.should == "16049999999"
    end

    it "should not double the country code if the number contains it" do
      number.number = "+16049999999"
      number.valid?
      number.number.should == "16049999999"
    end

    it "should remove dashes from numbers" do
      number.number = "604-999-9999"
      number.valid?
      number.number.should == "16049999999"
    end

    it "should remove () from a number" do
      number.number = "(604) 999-9999"
      number.valid?
      number.number.should == "16049999999"
    end
  end

  describe '#find_by_number' do
    let!(:number) { FactoryGirl.create(:number, :number => "6049999999") }

    it 'should find number without country code' do
      Number.find_by_number('6049999999').should == number
    end

    it 'should find number with country code' do
       Number.find_by_number('16049999999').should == number
    end
  end

  describe "forward_to" do
    let(:number) { FactoryGirl.create(:number) }
    subject { number }
    before do
      number.phone.should_receive(:number).and_return("16049999999")
    end

    its(:forward_to) { should == "+16049999999"}
  end

  describe "provision_number callback" do
    let(:number) { FactoryGirl.build(:number, :number => nil, :prefix => '604') }

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
    let(:number) { FactoryGirl.build(:number, :number => nil, :prefix => '604') }

    it "should set the number to the provisioned number on create" do
      adapter = Adapter.new
      adapter.stub :provision_number => "16048001234"
      number.should_receive(:adapter).any_number_of_times.and_return(adapter)
      number.save
      number.number.should == "16048001234"
    end
  end

  describe "phone_attributes" do
    it "should create a new phone with number" do
      pending
    end

    it "should find an existing phone by number" do
      fail
    end
  end
end
