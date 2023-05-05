class AddSubscribedToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :subscribed, :boolean, :default => true
    User.update_all(:subscribed => true)
  end

  def self.down
    remove_column :users, :subscribed
  end
end
