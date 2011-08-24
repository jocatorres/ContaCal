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
  end

  def update_kcal_limit
    current_user.update_attributes({:kcal_limit => params[:kcal_limit]})
  end
end
