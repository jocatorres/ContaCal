class ChangeSubscribedDailyToDefaultFalseOnUsers < ActiveRecord::Migration
  def self.up
    change_column :users, :subscribed_daily, :boolean, :default => false
  end

  def self.down
    change_column :users, :subscribed_daily, :boolean, :default => true
  end
end
