class AddSubscribedAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :subscribed_at, :date
  end

  def self.down
    remove_column :users, :subscribed_at
  end
end
