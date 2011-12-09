class AddBankBilletOurNumberToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :bank_billet_our_number, :string
  end

  def self.down
    remove_column :users, :bank_billet_our_number
  end
end
