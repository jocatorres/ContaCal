class UserFoodsController < ApplicationController
  before_filter :authenticate_user!
  def create
    @user_food = current_user.user_foods.create(params[:user_food].merge(:amount => 1))
  end

  def destroy
    @user_food = current_user.user_foods.find(params[:id])
    @user_food.destroy
  end
end
