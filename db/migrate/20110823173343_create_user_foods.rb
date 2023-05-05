class CreateUserFoods < ActiveRecord::Migration[4.2]
  def self.up
    create_table :user_foods do |t|
      t.integer :user_id
      t.integer :food_id
      t.float :amount
      t.string :meal, :limit => 20
      t.date :date

      t.timestamps
    end
    add_index :user_foods, [:user_id, :date]
    add_index :user_foods, [:date, :meal]
  end

  def self.down
    remove_index :user_foods, [:date, :meal]
    remove_index :user_foods, [:user_id, :date]
    drop_table :user_foods
  end
end
