# -*- encoding : utf-8 -*-
FactoryGirl.define do
  sequence :email do |n|
    "person#{n}@example.com"
  end
  factory :user do
    name 'Joaquim Torres'
    email
    password '123456'
    password_confirmation '123456'
  end
  factory :food do
    name 'Abacate batido com limão e açúcar'
    weight '90 Gramas - g'
    measure '2 Colher de sopa'
    kcal 164
    kind 'a'
  end
  factory :user_food do
    user
    food
    amount 1
    meal 'breakfast'
    date { Date.today }
  end
end
