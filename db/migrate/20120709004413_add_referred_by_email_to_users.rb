class AddReferredByEmailToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :referred_by_email, :string
  end

  def self.down
    remove_column :users, :referred_by_email
  end
end
