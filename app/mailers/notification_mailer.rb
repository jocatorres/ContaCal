# -*- encoding : utf-8 -*-
class NotificationMailer < ::ActionMailer::Base
  helper :application
  layout 'mailer'
  default :from => "Info ContaCal <info@contacal.com.br>"

  def welcome(user)
    @user = user
    mail(
      :from => "Info ContaCal <info@contacal.com.br>",
      :to => "#{user.name} <#{user.email}>",
      :subject => "[ContaCal] Seja bem vindo ao ContaCal!")    
  end

  def weekly(user)
    @user = user
    if (!user.nutri_email.blank?) 
      mail(
        :to => "#{user.name} <#{user.email}>",
        :cc => "#{user.nutri_name} <#{user.nutri_email}>",  
        :subject => "[ContaCal] Resumo semanal de calorias consumidas de #{user.name} (#{user.email})") 
    else    
      mail(
        :to => "#{user.name} <#{user.email}>",
        :subject => "[ContaCal] Resumo semanal de calorias consumidas")
    end
  end

  def beginning_of_day(user)
    @user = user
    @date = 1.day.ago.to_date  
    if (user.status == 1 or user.status == 10)
      mail(
        :to => "#{user.name} <#{user.email}>",
        :subject => "Está gostando do ContaCal?")
      if (user.expire_at < Date.today-1)
        user.update_attribute(:subscribed_daily, "f")
      end
    else
      if (!user.nutri_email.blank?) 
        mail(
          :to => "#{user.name} <#{user.email}>",
          :cc => "#{user.nutri_name} <#{user.nutri_email}>",
          :subject => "[ContaCal] Resumo das calorias de #{user.name} (#{user.email}) em #{I18n.l(@date)}")
      else
        mail(
          :to => "#{user.name} <#{user.email}>",
          :subject => "[ContaCal] Resumo de suas calorias em #{I18n.l(@date)}")
      end
    end
  end

#  def end_of_day(user)
#    @user = user
#    @date = Date.today
#    mail(:to => "#{user.name} <#{user.email}>",
#      :subject => "Resumo de suas calorias de hoje (#{I18n.l(@date)})")
#  end

  def new_food(user, food)
    @user = user
    @food = food
    mail(
      :from => "Info ContaCal <info@contacal.com.br>",  
      :content_type => "text/plain",
#      :from => "#{user.name} <#{user.email}>",
      :to => "Info ContaCal <info@contacal.com.br>",
      :subject => "[ContaCal] Sugestão de novo alimento") do |format|
        format.text
    end
  end

end