class UserWeight < ActiveRecord::Base
  belongs_to :user
  validates :user, :date, :presence => true
  validates :weight, :numericality => true
  attr_accessible :weight, :date
end
