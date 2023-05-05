class UserFriends < ApplicationRecord
  belongs_to :user
  validates :user, :friend_name, :friend_email, :date, :presence => true
end
