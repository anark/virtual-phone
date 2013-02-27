class MockAdapter < Adapter
  def provision_number(prefix)
    Faker::Base.numerify("#{prefix}#######")
  end

  def release_number(number)
    true
  end
end
