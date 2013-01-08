Factory.define :phone do |f|
  f.number Faker::PhoneNumber.phone_number
end
