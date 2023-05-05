class DeviseMailer < Devise::Mailer
  include Devise::Mailers::Helpers
  layout 'mailer'
end