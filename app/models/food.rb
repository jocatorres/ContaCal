# -*- encoding : utf-8 -*-
class Food < ActiveRecord::Base
  has_many :user_foods
  validates :name, :weight, :measure, :kcal, :presence => true

  Consumables = %w( a b c )
  Expendables = %w( d )

  validates :kind, :inclusion => Consumables + Expendables
end
