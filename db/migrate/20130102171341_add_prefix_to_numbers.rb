class AddPrefixToNumbers < ActiveRecord::Migration
  def change
    add_column :numbers, :prefix, :string
  end
end
