# -*- encoding : utf-8 -*-
class FoodsController < ApplicationController
  before_filter :authenticate_user!
  layout 'devise'
  
  def new
    @food = Food.new
  end
  
  def create
    @food = Food.new(params[:food])
    
    if @food.valid?
      NotificationMailer.new_food(current_user, @food).deliver
      redirect_to new_food_path, notice: 'Sua sugestão foi enviada com sucesso.'
    else
      render action: "new"
    end
  end
end
