# -*- encoding : utf-8 -*-
class AddNameToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :name, :string
  end

  def self.down
    remove_column :users, :name
  end
end
