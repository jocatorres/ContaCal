class UserWeight < ApplicationRecord
  belongs_to :user
  validates :user, :date, :presence => true
  validates :weight, :numericality => true
end
