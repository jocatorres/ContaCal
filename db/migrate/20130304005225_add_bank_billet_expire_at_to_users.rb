class AddBankBilletExpireAtToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :bank_billet_expire_at, :date
  end

  def self.down
    remove_column :users, :bank_billet_expire_at
  end
end
