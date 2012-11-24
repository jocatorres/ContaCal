class AddRenewedAtUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :renew_at, :date
  end

  def self.down
    remove_column :users, :renew_at
  end
end
