class CreateUserWeights < ActiveRecord::Migration
  def self.up
    create_table :user_weights do |t|
      t.integer :user_id
      t.float :weight
      t.date :date

      t.timestamps
    end
  end

  def self.down
    drop_table :user_weights
  end
end
