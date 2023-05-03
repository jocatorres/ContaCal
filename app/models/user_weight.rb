class UserWeight < ActiveRecord::Base
  belongs_to :user
  validates :user, :date, :presence => true
  validates :weight, :numericality => true
end
