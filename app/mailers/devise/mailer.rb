class Devise::Mailer < ::ActionMailer::Base
  include Devise::Mailers::Helpers
  layout 'mailer'

  def reset_password_instructions(record, token, opts={})
    @token = token
    devise_mail(record, :reset_password_instructions, opts)
  end

  def unlock_instructions(record)
    devise_mail(record, :unlock_instructions)
  end
end