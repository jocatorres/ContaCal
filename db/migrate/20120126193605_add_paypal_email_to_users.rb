class AddPaypalEmailToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :paypal_email, :string
  end

  def self.down
    remove_column :users, :paypal_email
  end
end
