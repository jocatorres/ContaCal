class DashboardController < ApplicationController
  before_filter :authenticate_user!
  autocomplete :food, :name, :full => true
  
  def index
    begin
      @date = Date.parse("#{params[:year]}-#{params[:month]}-#{params[:day]}")
    rescue
      @date = Date.today
    end
    @next_day = @date+1.day
    @previous_day = @date-1.day
    
    @total_kcal = current_user.consumed_kcal(:date => @date)
    @percent_kcal_kind_a = current_user.consumed_kcal(:date => @date, :kind => 'a')/@total_kcal*100
    @percent_kcal_kind_b = current_user.consumed_kcal(:date => @date, :kind => 'b')/@total_kcal*100
    @percent_kcal_kind_c = current_user.consumed_kcal(:date => @date, :kind => 'c')/@total_kcal*100
    
  end

  def update_kcal_limit
    current_user.update_attributes({:kcal_limit => params[:kcal_limit]})
  end
end
