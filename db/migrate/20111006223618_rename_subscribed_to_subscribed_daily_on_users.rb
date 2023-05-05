class RenameSubscribedToSubscribedDailyOnUsers < ActiveRecord::Migration[4.2]
  def self.up
    rename_column :users, :subscribed, :subscribed_daily
    change_column_default :users, :subscribed_daily, true
  end

  def self.down
    rename_column :users, :subscribed_daily, :subscribed
  end
end
