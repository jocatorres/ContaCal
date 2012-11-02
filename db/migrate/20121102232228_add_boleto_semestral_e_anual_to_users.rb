class AddBoletoSemestralEAnualToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :bank_billet_our_number_6, :string
    add_column :users, :bank_billet_link_6, :string
    add_column :users, :bank_billet_our_number_12, :string
    add_column :users, :bank_billet_link_12, :string
  end

  def self.down
    remove_column :users, :bank_billet_link_12
    remove_column :users, :bank_billet_our_number_12
    remove_column :users, :bank_billet_link_6
    remove_column :users, :bank_billet_our_number_6
  end
end
