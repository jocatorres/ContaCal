# -*- encoding : utf-8 -*-
class NotificationMailer < ::ActionMailer::Base
  helper :application
  layout 'mailer'
  default :from => "ContaCal <contato@contacal.com.br>"

  def welcome(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>",
      :subject => "Seja bem vindo ao ContaCal!")    
  end

  def weekly(user)
    @user = user
    mail(:to => "#{user.name} <#{user.email}>",
      :subject => "Resumo semanal de calorias consumidas")
  end

  def beginning_of_day(user)
    @user = user
    @date = 1.day.ago.to_date
    if ((user.status == 1 or user.status == 10) and user.bank_billet_link.nil?)
      mail(:to => "#{user.name} <#{user.email}>",
        :subject => "Está gostando do ContaCal?")
      if (user.expire_at < Date.today-1)
        user.update_attribute(:subscribed_daily, "f")
      end
    else  
      if (user.email == "jtorres@jig.com.br")
        mail(:to => "#{user.name} <#{user.email}>, joaquim.torres@locaweb.com.br",
          :subject => "[ContaCal] Resumo de suas calorias em #{I18n.l(@date)}")
      else
        mail(:to => "#{user.name} <#{user.email}>",
          :subject => "[ContaCal] Resumo de suas calorias em #{I18n.l(@date)}")
      end  
    end
  end

  def end_of_day(user)
#    @user = user
#    @date = Date.today
#    mail(:to => "#{user.name} <#{user.email}>",
#      :subject => "Resumo de suas calorias de hoje (#{I18n.l(@date)})")
  end

  def new_food(user, food)
    @user = user
    @food = food
    mail(
 #     :from => "#{user.name} <#{user.email}>",
      :to => "Info ContaCal <sugestao@contacal.com.br>",
      :subject => "Sugestão de novo alimento")
  end

end