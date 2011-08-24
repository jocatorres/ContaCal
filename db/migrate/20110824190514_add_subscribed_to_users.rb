class AddSubscribedToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :subscribed, :boolean, :default => true
    User.update_all(:subscribed => true)
  end

  def self.down
    remove_column :users, :subscribed
  end
end
