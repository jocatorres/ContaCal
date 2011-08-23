# -*- encoding : utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

User.delete_all
user = User.create!({
  :name => "Quentin Tarantino",
  :email => "quentin@example.com",
  :password => "test123"
})
user.confirm!

json = File.read(Rails.root.join('db','foods.json'))
foods = JSON.parse(json)['data']
foods.each do |f|
  Food.create!({
    :name => f['nome'],
    :weight => f['peso'],
    :measure => f['medida_caseira'],
    :kcal => f['kcal'],
    :type => f['tipo'],
  })
end