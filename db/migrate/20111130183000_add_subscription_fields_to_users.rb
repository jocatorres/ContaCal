class AddSubscriptionFieldsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :status, :integer
    add_column :users, :bank_billet_link, :string
    add_column :users, :expire_at, :date
  end

  def self.down
    remove_column :users, :expire_at
    remove_column :users, :bank_billet_link
    remove_column :users, :status
  end
end
