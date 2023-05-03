# -*- encoding : utf-8 -*-
class UserFoodsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @user_food = current_user.user_foods.create(user_food_params.merge(:amount => 1))
  end

  def update
    @user_food = current_user.user_foods.find(params[:id])
    @user_food.update_attributes(user_food_params)
  end

  def destroy
    @user_food = current_user.user_foods.find(params[:id])
    @user_food.destroy
  end     
  
  private 
  
  def user_food_params 
    params.require(:user_food).permit(:food, :food_id, :amount, :meal, :date)
  end 
end
