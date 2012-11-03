class RegistrationsController < Devise::RegistrationsController

  protected
  def after_inactive_sign_up_path_for(resource)
    '/users/confirm'
  end

  def after_sign_out_path_for(resource_or_scope)
    "https://docs.google.com/a/jig.com.br/spreadsheet/viewform?formkey=dFBMUV9fd2x4aVZJOFJ2V3JVTmxlQmc6MQ"
  end  

end