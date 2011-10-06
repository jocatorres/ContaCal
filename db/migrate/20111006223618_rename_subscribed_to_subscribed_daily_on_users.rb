class RenameSubscribedToSubscribedDailyOnUsers < ActiveRecord::Migration
  def self.up
    rename_column :users, :subscribed, :subscribed_daily
  end

  def self.down
    rename_column :users, :subscribed_daily, :subscribed
  end
end
