class AddNutriMailAndNameToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :nutri_email, :string
    add_column :users, :nutri_name, :string
  end

  def self.down
    remove_column :users, :nutri_name
    remove_column :users, :nutri_email
  end
end
