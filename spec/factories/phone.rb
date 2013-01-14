FactoryGirl.define do
  factory :phone do
    number Faker::PhoneNumber.phone_number
  end
end
