class CreateFoods < ActiveRecord::Migration
  def self.up
    create_table :foods do |t|
      t.string :name
      t.string :weight, :limit => 40
      t.string :measure, :limit => 40
      t.integer :kcal
      t.string :type, :limit => 1

      t.timestamps
    end
  end

  def self.down
    drop_table :foods
  end
end
