# -*- encoding : utf-8 -*-
class FoodsController < ApplicationController
  before_filter :authenticate_user!
  layout 'devise'
  
  def new
    @food = Food.new
  end
  
  def create
    @food = Food.new(food_params)
    
    if !@food.name.blank?
      NotificationMailer.new_food(current_user, @food).deliver  
      @food.name.gsub!('+', ' ')
      @food.update_attribute(:kind, "h")      
      @food.update_attribute(:suggester_id, current_user.id)
      @food.save
      redirect_to new_food_path, notice: '<center>Sugestão enviada com sucesso!</center>'
    else
      @food.errors.add(:name, :empty)
      render action: "new"
    end    
  end
  
  private 
  
  def food_params 
    params.require(:food).permit(:name, :weight, :measure, :kcal, :kind)
  end
end
