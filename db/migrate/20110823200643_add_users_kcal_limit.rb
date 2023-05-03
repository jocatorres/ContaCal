class AddUsersKcalLimit < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :kcal_limit, :integer
  end

  def self.down
    remove_column :users, :kcal_limit
  end
end
