class AddPhoneToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :phone, :string
  end

  def self.down
    remove_column :users, :phone
  end
end
