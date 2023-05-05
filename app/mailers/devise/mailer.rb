class Devise::Mailer < ::ActionMailer::Base
  include Devise::Mailers::Helpers
  layout 'mailer'

  def reset_password_instructions(record, token, opts = {})
    devise_mail(record, :reset_password_instructions)
  end

  def unlock_instructions(record, token, opts = {})
    devise_mail(record, :unlock_instructions)
  end
end