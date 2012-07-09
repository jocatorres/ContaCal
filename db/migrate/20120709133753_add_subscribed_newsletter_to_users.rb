class AddSubscribedNewsletterToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :subscribed_newsletter, :boolean, :default => true  
    User.update_all(:subscribed_newsletter => true)
  end

  def self.down
    remove_column :users, :subscribed_newsletter
  end
end
