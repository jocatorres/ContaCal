# -*- encoding : utf-8 -*-
class Food < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :weight
  validates_presence_of :measure
  validates_presence_of :kcal
  validates_inclusion_of :kind, :in => %w( a b c )
  
  attr_accessible :name, :weight, :measure, :kcal, :kind
end
