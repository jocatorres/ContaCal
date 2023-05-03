class PopulateFoods < ActiveRecord::Migration[4.2]
  def self.up
    lines = File.open(Rails.root.join('db','foods.txt')).readlines
    lines.each do |line|
      p = line.split("|")
      Food.create!({
        :name => p[0],
        :weight => p[1],
        :measure => p[2],
        :kcal => p[3],
        :kind => p[4],
      })
    end
  end

  def self.down
    Food.delete_all
  end
end
