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
    mail(:to => "#{user.name} <#{user.email}>",
      :subject => "Resumo de suas calorias em #{I18n.l(@date)}")
  end

  def end_of_day(user)
    @user = user
    @date = Date.today
    mail(:to => "#{user.name} <#{user.email}>",
      :subject => "Resumo de suas calorias de hoje (#{I18n.l(@date)})")
  end
  
  def new_food(user, food)
    @user = user
    @food = food
    mail(
      :from => "#{user.name} <#{user.email}>",
      :to => "ContaCal <info@contacal.com.br>",
      :cc => "Joca Torres <jtorres@jig.com.br>",
      :subject => "Sugestão de novo alimento")
  end

end