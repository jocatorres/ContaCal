# -*- encoding : utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

if Rails.env.development?
  User.delete_all
  user = User.create!({
    :name => "Quentin Tarantino",
    :email => "quentin@example.com",
    :password => "test123"
  })

  Food.delete_all
  lines = File.open(Rails.root.join('db','foods.txt')).readlines
  lines.each do |line|
    p = line.split("|")
    Food.create!({
      :name => p[0],
      :weight => p[1],
      :measure => p[2],
      :kcal => p[3],
      :kind => p[4],
    })
  end
  
  UserFood.delete_all
  uf = UserFood.new(:user => user, :food => Food.first, :amount => 2, :meal => 'breakfast', :date => Date.today)
  uf.user = user
  uf.save!
end