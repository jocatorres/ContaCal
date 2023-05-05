class AddUserFoodsKcal < ActiveRecord::Migration[4.2]
  def self.up
    add_column :user_foods, :kcal, :float
  end

  def self.down
    remove_column :user_foods, :kcal
  end
end
