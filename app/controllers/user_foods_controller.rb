class UserFoodsController < ApplicationController
  before_filter :authenticate_user!
  def create
    current_user.user_foods.create(params[:user_food].merge(:amount => 1))
    redirect_to root_url
  end
end
