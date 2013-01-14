FactoryGirl.define do
  factory :number do
    number Faker::PhoneNumber.phone_number
    phone { |f| f.association(:phone) }
    prefix { number[0..2] }
  end
end
