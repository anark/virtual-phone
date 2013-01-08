class MockAdapter < Adapter
  def provision_number(prefix)
    Faker::Base.numerify("#{prefix}#######")
  end
end
