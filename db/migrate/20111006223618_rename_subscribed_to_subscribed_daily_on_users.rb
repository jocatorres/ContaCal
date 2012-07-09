class RenameSubscribedToSubscribedDailyOnUsers < ActiveRecord::Migration
  def self.up
    rename_column :users, :subscribed, :subscribed_daily, :default => true 
  end

  def self.down
    rename_column :users, :subscribed_daily, :subscribed
  end
end
