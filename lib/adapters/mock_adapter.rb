class MockAdapter < Adapter
  def provision_number(prefix)
    number = Faker::Base.numerify("#{prefix}#######")
    adapter_identifier = Random.rand(1024)
    [ number, adapter_identifier ]
  end

  def release_number(number)
    true
  end
end
