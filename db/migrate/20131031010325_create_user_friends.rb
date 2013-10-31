class CreateUserFriends < ActiveRecord::Migration
  def self.up
    create_table :user_friends do |t|
      t.integer :user_id
      t.string :friend_name
      t.string :friend_email
      t.date :date

      t.timestamps
    end
  end

  def self.down
    drop_table :user_friends
  end
end
