class AddReferredByEmailToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :referred_by_email, :string
  end

  def self.down
    remove_column :users, :referred_by_email
  end
end
