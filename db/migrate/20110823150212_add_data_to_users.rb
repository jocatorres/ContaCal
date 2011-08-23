class AddDataToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :cpf, :string
    add_column :users, :address_street_and_number, :string
    add_column :users, :address_city, :string
    add_column :users, :address_state, :string
    add_column :users, :address_zipcode, :string
  end

  def self.down
    remove_column :users, :address_zipcode
    remove_column :users, :address_state
    remove_column :users, :address_city
    remove_column :users, :address_street_and_number
    remove_column :users, :cpf
  end
end
