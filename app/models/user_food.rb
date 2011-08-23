class UserFood < ActiveRecord::Base
  belongs_to :user
  belongs_to :food
  validates :user, :food, :date, :presence => true
  validates :amount, :numericality => true
  validates :meal, :inclusion => %w( breakfast brunch lunch tea dinner supper )
  attr_accessible :food, :food_id, :amount, :meal, :date
  before_save :set_kcal

  protected
  def set_kcal
    return if amount.nil? or food.nil? or food.kcal.nil?
    self.kcal = amount*food.kcal
  end
end
