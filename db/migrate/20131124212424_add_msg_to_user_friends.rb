class AddMsgToUserFriends < ActiveRecord::Migration[4.2]
  def self.up
    add_column :user_friends, :msg, :string
  end

  def self.down
    remove_column :user_friends, :msg
  end
end
