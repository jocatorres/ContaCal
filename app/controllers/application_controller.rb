class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
    render :inline => "alow", :layout => "application"
  end
end
