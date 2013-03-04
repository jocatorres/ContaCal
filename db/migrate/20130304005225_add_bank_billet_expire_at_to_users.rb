class AddBankBilletExpireAtToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :bank_billet_expire_at, :date
  end

  def self.down
    remove_column :users, :bank_billet_expire_at
  end
end
