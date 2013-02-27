FactoryGirl.define do
  factory :number, :class => MockNumber do
    number Faker::PhoneNumber.phone_number
    phone { |f| f.association(:phone) }
    prefix { number[0..2] }
  end
end
