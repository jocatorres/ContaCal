class ChangeSubscribedDailyToDefaultFalseOnUsers < ActiveRecord::Migration[4.2]
  def self.up
    change_column :users, :subscribed_daily, :boolean, :default => false
  end

  def self.down
    change_column :users, :subscribed_daily, :boolean, :default => true
  end
end
