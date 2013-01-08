require "spec_helper"

describe Phone do
  describe "validations" do
    subject { Factory(:phone) }
    it { should validate_presence_of :number }
    it { should validate_uniqueness_of(:number) }
    it { should allow_value("6049999999").for(:number) }
    it { should_not allow_value("16049999999").for(:number) }
    it { should_not allow_value("604-999-9999").for(:number) }
  end

  describe "associations" do
    it { should have_many :numbers }
  end
end
