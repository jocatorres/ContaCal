class AddBankBilletIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :bank_billet_id, :integer
  end

  def self.down
    remove_column :users, :bank_billet_id
  end
end
