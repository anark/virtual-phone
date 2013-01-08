class SwitchNumberToSti < ActiveRecord::Migration
  def up
    add_column :numbers, :type, :string
    Number.reset_column_information
    Number.all.each do |number|
      number.update_attribute :type, "#{number.adapter_type.capitalize}Number"
    end
    remove_column :numbers, :adapter_type
  end

  def down
    add_column :numbers, :adapter_type, :string
    remove_column :numbers, :type
  end
end
