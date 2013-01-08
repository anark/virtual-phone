class Number < ActiveRecord::Base
  validates_format_of :number, :with => /\A\d{10}\z/
  validates_uniqueness_of :number
  validates_presence_of :number, :phone

  belongs_to :phone

  before_validation :provision_number, :on => :create, :unless => :number?

  attr_accessor :adapter

  def self.find_by_number(number)
    super(number) || super(number[1..-1])
  end

  def provision_number
    self.number = adapter.provision_number(prefix) if prefix
  end

  def forward_to=(forward_to)
    self.phone = Phone.find_or_create_by_number(forward_to)
  end

  def forward_to
    phone.number if phone
  end

  def incoming_call(from)
    adapter.forward_call(self, from)
  end

  def incoming_sms(from, text)
    adapter.forward_sms(self, from, text)
  end

  def adapter_class
    raise NotImplementedError
  end

  protected

  def adapter
    @adapter ||= adapter_class.send(:new)
  end
end
