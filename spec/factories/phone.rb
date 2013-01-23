FactoryGirl.define do
  factory :phone do
    number Faker::PhoneNumber.phone_number
    country_code "US"
  end
end
