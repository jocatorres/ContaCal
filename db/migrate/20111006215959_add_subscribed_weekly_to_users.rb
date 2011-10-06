class AddSubscribedWeeklyToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :subscribed_weekly, :boolean, :default => true
    User.update_all(:subscribed_weekly => true)
  end

  def self.down
    remove_column :users, :subscribed_weekly
  end
end
