class AddDeletedAtToUsers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :deleted_at, :datetime
  end

  def self.down
    remove_column :users, :deleted_at
  end
end
