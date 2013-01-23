require "spec_helper"

describe Phone do
  describe "validations" do
    subject { FactoryGirl.create(:phone) }
    it { should validate_presence_of :number }
    it { should validate_uniqueness_of(:number) }
    it { should allow_value("6049999999").for(:number) }
    it { should_not allow_value("00000").for(:number) }
  end

  describe "number=" do
    let(:phone) { Phone.new :country_code => "US" }
    it "should add the appropriate country code to the number" do
      phone.number = "6049999999"
      phone.valid?
      phone.number.should == "16049999999"
    end

    it "should not double the country code if the number contains it" do
      phone.number = "+16049999999"
      phone.valid?
      phone.number.should == "16049999999"
    end

    it "should remove dashes from numbers" do
      phone.number = "604-999-9999"
      phone.valid?
      phone.number.should == "16049999999"
    end

    it "should remove () from a number" do
      phone.number = "(604) 999-9999"
      phone.valid?
      phone.number.should == "16049999999"
    end
  end

  describe "associations" do
    it { should have_many :numbers }
  end
end
