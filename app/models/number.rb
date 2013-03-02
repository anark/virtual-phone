class Number < ActiveRecord::Base
  validates :number, :presence => true, :uniqueness => true, :phony_plausible => true
  validates :prefix, :presence => true, :format => { :with => /\A\d{3}\z/ }
  validates :phone, :presence => true
  belongs_to :phone

  before_validation :provision_number, :on => :create, :unless => :number?

  after_destroy :release_number

  phony_normalize :number, :default_country_code => "CA"

  accepts_nested_attributes_for :phone

  attr_accessor :adapter

  def self.find_by_number(number)
    super(number) || super("1#{number}")
  end

  def provision_number
    return unless prefix
    number, adapter_identifier = adapter.provision_number(prefix)
    self.number = number
    self.adapter_identifier = adapter_identifier
  end

  def release_number
    adapter.release_number(self)
  end

  def forward_to
    Phony.formatted(phone.number, :format => :international, :spaces => "") if phone
  end

  def incoming_call(from)
    adapter.forward_call(self, from)
  end

  def incoming_sms(from, text)
    adapter.forward_sms(self, from, text)
  end

  def adapter_class
    raise NotImplementedError, "adapter_class is not implemented for #{self.inspect}"
  end

  def adapter
    @adapter ||= adapter_class.send(:new)
  end

  def phone_attributes=(phone_attributes)
    normalized_number = PhonyRails.normalize_number(phone_attributes[:number], :country_code => phone_attributes[:country_code])
    self.phone = Phone.find_or_initialize_by_number(normalized_number)
    self.phone.country_code ||= phone_attributes[:country_code]
  end
end
