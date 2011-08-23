class UserFood < ActiveRecord::Base
  belongs_to :user
  belongs_to :food
  validates :user, :food, :date, :presence => true
  validates :amount, :numericality => true
  validates :meal, :inclusion => %w( breakfast brunch lunch tea dinner supper )
end
