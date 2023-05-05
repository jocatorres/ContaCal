class AddBankBilletOurNumberToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :bank_billet_our_number, :string
  end

  def self.down
    remove_column :users, :bank_billet_our_number
  end
end
