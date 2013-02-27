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
    self.number = adapter.provision_number(prefix) if prefix
  end

  def release_number
    adapter.release_number(number)
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
    raise NotImplementedError
  end

  protected

  def adapter
    @adapter ||= adapter_class.send(:new)
  end
end
