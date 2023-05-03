class AddSubscribedAtToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :subscribed_at, :date
  end

  def self.down
    remove_column :users, :subscribed_at
  end
end
