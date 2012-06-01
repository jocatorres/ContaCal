# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout_by_resource

  protected
  def redirect_location(scope, resource)
    resource.update_attribute(:deleted_at, nil) unless resource.deleted_at.nil?
    stored_location_for(scope) || after_sign_in_path_for(resource)
  end

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end

  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end

  helper_method :mobile_device?
end
