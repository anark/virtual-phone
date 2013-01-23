class AddCountryCodeToPhones < ActiveRecord::Migration
  def change
    add_column :phones, :country_code, :string, :default => "CA"

    Phone.all.each do |phone|
      current_number = phone.read_attribute :number
      phone.update_attribute :number, "1#{current_number}"
    end
  end
end
