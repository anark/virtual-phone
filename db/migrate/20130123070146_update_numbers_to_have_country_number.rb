class UpdateNumbersToHaveCountryNumber < ActiveRecord::Migration
  def up
    Number.all.each do |number|
      current_number = number.read_attribute :number
      number.update_attribute :number, "1#{current_number}"
    end
  end

  def down
  end
end
