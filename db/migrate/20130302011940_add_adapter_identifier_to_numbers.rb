class AddAdapterIdentifierToNumbers < ActiveRecord::Migration
  def change
    add_column :numbers, :adapter_identifier, :string
  end
end
