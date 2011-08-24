class NotificationMailer < ::ActionMailer::Base
  helper :application
  layout 'mailer'
  default :from => "ContaCal <contato@contacal.com.br>"

  def beginning_of_day(user)
    @user = user
    @date = 1.day.ago.to_date
    mail(:to => "#{user.name} <#{user.email}>",
      :subject => "Resumo de suas calorias em #{I18n.l(@date)}")
  end

  def end_of_day(user)
    @user = user
    @date = Date.today
    mail(:to => "#{user.name} <#{user.email}>",
      :subject => "Resumo de suas calorias de hoje (#{I18n.l(@date)})")
  end

end