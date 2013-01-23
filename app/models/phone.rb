class Phone < ActiveRecord::Base
  validates :number, :uniqueness => true, :presence => true, :phony_plausible => true
  has_many :numbers
  phony_normalize :number
end
