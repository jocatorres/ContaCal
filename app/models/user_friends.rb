class UserFriends < ActiveRecord::Base
  belongs_to :user
  validates :user, :date, :presence => true
  attr_accessible  :friend_name, :friend_email, :date
end
