class AddBankBilletIdToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :bank_billet_id, :integer
  end

  def self.down
    remove_column :users, :bank_billet_id
  end
end
