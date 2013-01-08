class CreateNumbers < ActiveRecord::Migration
  def self.up
    create_table :numbers do |t|
      t.string :number
      t.integer :phone_id
      t.string :adapter_type
      t.timestamps
    end
  end

  def self.down
    drop_table :numbers
  end
end
