class AddSmallPortionsToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :small_portions, :boolean
  end

  def self.down
    remove_column :users, :small_portions
  end
end
