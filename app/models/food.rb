class Food < ActiveRecord::Base
  validates_presence_of :name
  validates_presence_of :weight
  validates_presence_of :measure
  validates_presence_of :kcal
  validates_inclusion_of :type, :in => %w( a b c )
end
