class NotificationMailer < ::ActionMailer::Base
  layout 'mailer'
  default :from => "ContaCal <contato@contacal.com.br>"

  def beginning_of_day(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>",
      :subject => "Resumo de suas calorias em #{I18n.l(1.day.ago.to_date)}")
  end

end