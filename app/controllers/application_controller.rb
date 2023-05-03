# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  
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
         
  before_action :prepare_for_mobile

  def mobile_device?
    if session[:mobile_param]
      session[:mobile_param] == "1"
    else
      request.user_agent =~ /Mobile|webOS/
    end
  end
  helper_method :mobile_device?
  
  def prepare_for_mobile
    session[:mobile_param] = params[:mobile] if params[:mobile]
    request.format = :mobile if mobile_device? && !request.xhr?
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: User::ATTRIBUTES_ACCESSIBLE)
    devise_parameter_sanitizer.permit(:account_update, keys: User::ATTRIBUTES_ACCESSIBLE)
  end
end
