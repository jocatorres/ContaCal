# -*- encoding : utf-8 -*-
class FoodsController < ApplicationController
  before_filter :authenticate_user!
  layout 'devise'
  
  def new
    @food = Food.new
  end
  
  def create
    @food = Food.new(params[:food])
    
    if !@food.name.blank?
      NotificationMailer.new_food(current_user, @food).deliver  
      @food.name.gsub!('+', ' ')
      @food.update_attribute(:kind, "h")      
      @food.update_attribute(:suggester_id, current_user.id)
      @food.save
      redirect_to new_food_path, notice: '<center>Sua sugestão foi enviada com sucesso!&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
    else
      @food.errors.add(:name, :empty)
      render action: "new"
    end    
  end
end
