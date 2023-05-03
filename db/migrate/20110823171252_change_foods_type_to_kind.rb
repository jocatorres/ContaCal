class ChangeFoodsTypeToKind < ActiveRecord::Migration[4.2]
  def self.up
    rename_column :foods, :type, :kind
  end

  def self.down
    rename_column :foods, :kind, :type
  end
end
