class AddSuggesterToFoods < ActiveRecord::Migration[4.2]
  def self.up
    add_column :foods, :suggester_id, :integer
  end

  def self.down
    remove_column :foods, :suggester_id
  end
end
