# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :layout_by_resource

  protected
  def after_sign_in_path_for(resource)
    resource.update_attribute(:deleted_at, nil) unless resource.deleted_at.nil?
    root_path
  end

  def layout_by_resource
    if devise_controller?
      "devise"
    else
      "application"
    end
  end
end
