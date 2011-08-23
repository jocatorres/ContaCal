class DashboardController < ApplicationController
  before_filter :authenticate_user!
  autocomplete :food, :name, :full => true

  def update_kcal_limit
    current_user.update_attributes({:kcal_limit => params[:kcal_limit]})
  end
end
