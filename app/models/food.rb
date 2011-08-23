# -*- encoding : utf-8 -*-
class Food < ActiveRecord::Base
  has_many :user_foods
  validates :name, :weight, :measure, :kcal, :presence => true
  validates :kind, :inclusion => %w( a b c )
  
  attr_accessible :name, :weight, :measure, :kcal, :kind
end
