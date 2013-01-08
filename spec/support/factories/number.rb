Factory.define :number do |f|
  f.number Faker::PhoneNumber.phone_number
  f.phone { |f| f.association(:phone) }
end
