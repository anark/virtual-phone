class Phone < ActiveRecord::Base
  validates_uniqueness_of :number
  validates_format_of :number, :with => /\A\d{10}\z/
  validates_uniqueness_of :number
  validates_presence_of :number

  has_many :numbers
end
