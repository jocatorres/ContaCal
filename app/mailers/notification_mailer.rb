# -*- encoding : utf-8 -*-
class NotificationMailer < ::ActionMailer::Base
  helper :application
  layout 'mailer'
  default :from => "ContaCal <contato@contacal.com.br>"

  def welcome(user)
    @user = user
    puts "welcome: mail(:to => #{user.name} <#{user.email}>,..."
    mail(:to => "#{user.name} <#{user.email}>",
      :subject => "Seja bem vindo ao ContaCal!")    
  end

  def weekly(user)
    @user = user
    puts "Mandando email semanal"
    puts "weekly: mail(:to => #{user.name} <#{user.email}>,..."
#    mail(:to => "#{user.name} <#{user.email}>",
#      :subject => "Resumo semanal de calorias consumidas")
    if (!user.nutri_email.blank?) 
      puts "Tem nutri!"
      puts "weekly - nutri: mail(:to => #{user.nutri_name} <#{user.nutri_email}>,..."
#      mail(:to => "#{user.nutri_name} <#{user.nutri_email}>",  
#        :subject => "Resumo semanal de calorias consumidas de #{user.name} (#{user.email})")
    end
  end

  def beginning_of_day(user)
    @user = user
    @date = 1.day.ago.to_date
    puts "[ContaCal] Resumo das calorias de [#{user.name}] [#{user.email}] em [#{I18n.l(@date)}] - nutri = [#{user.nutri_name}] [#{user.nutri_email}]."
    if (user.status == 1 or user.status == 10)
      puts "Eh trial."
      puts "daily - trial: mail(:to => #{user.name} <#{user.email}>,..."
#      mail(:to => "#{user.name} <#{user.email}>",
#        :subject => "Está gostando do ContaCal?")
      puts "enviou..."
      if (user.expire_at < Date.today-1)
        user.update_attribute(:subscribed_daily, "f")
      end
      puts "analisou expire_at"
    else  
      puts "daily - nao trial: mail(:to => #{user.name} <#{user.email}>,..."
#      mail(:to => "#{user.name} <#{user.email}>",
#        :subject => "[ContaCal] Resumo de suas calorias em #{I18n.l(@date)}")
      puts "Nao eh trial. Vamos ver se tem nutri. [#{user.nutri_name}] [<#{user.nutri_email}]"
      if (!user.nutri_email.blank?) 
         puts "Tem nutri!"
         puts "daily - nao trial - nutri: mail(:to => #{user.nutri_name} <#{user.nutri_email}>,..."
#        mail(:to => "#{user.nutri_name} <#{user.nutri_email}>",
#          :subject => "[ContaCal] Resumo das calorias de #{user.name} (#{user.email}) em #{I18n.l(@date)}")
      end
    end
    puts "chegou ao fim."
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
    puts "new_food: mail(:to => #{user.name} <#{user.email}>,..."
    mail(
 #     :from => "#{user.name} <#{user.email}>",
      :to => "Info ContaCal <sugestao@contacal.com.br>",
      :subject => "Sugestão de novo alimento")
  end

end