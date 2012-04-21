# -*- encoding : utf-8 -*-
class NotificationMailer < ::ActionMailer::Base
  helper :application
  layout 'mailer'
  default :from => "ContaCal <info@contacal.com.br>"

  def welcome(user)
    @user = user
    mail(
      :from => "Info ContaCal <info@contacal.com.br>",
      :to => "#{user.name} <#{user.email}>",
      :subject => "Seja bem vindo ao ContaCal!")    
  end

  def weekly(user)
    @user = user
    mail(
      :to => "#{user.name} <#{user.email}>",
      :subject => "Resumo semanal de calorias consumidas")
    if (!user.nutri_email.blank?) 
      mail(
        :to => "#{user.nutri_name} <#{user.nutri_email}>",  
        :subject => "Resumo semanal de calorias consumidas de #{user.name} (#{user.email})")
    end
  end

  def beginning_of_day(user)
    @user = user
    @date = 1.day.ago.to_date  
    puts "mandando para [#{user.email}] - nutri = [#{user.nutri_email}]"      
     puts "1"      
    if (user.status == 1 or user.status == 10)
      puts "2"
      mail(
        :to => "Joca <jtorres@jig.com.br>",
#        :to => "#{user.name} <#{user.email}>",
        :subject => "Está gostando do ContaCal?")
        puts "3"
      if (user.expire_at < Date.today-1)
        puts "4"
        user.update_attribute(:subscribed_daily, "f")
      end
      puts "5"
    else  
      puts "6"
      mail(
        :to => "Joca <jtorres@jig.com.br>",
#        :to => "#{user.name} <#{user.email}>",
        :subject => "[ContaCal] Resumo de suas calorias em #{I18n.l(@date)}")
        puts "7"
      if (!user.nutri_email.blank?) 
        puts "8"
        mail(
          :to => "Joca <jtorres@jig.com.br>",
#          :to => "#{user.nutri_name} <#{user.nutri_email}>",
          :subject => "[ContaCal] Cópia do resumo das calorias de #{user.name} (#{user.email}) em #{I18n.l(@date)}")
          puts "9"
      end
puts "10"
    end
    puts "11"
  end

#  def end_of_day(user)
#    @user = user
#    @date = Date.today
#    mail(:to => "#{user.name} <#{user.email}>",
#      :subject => "Resumo de suas calorias de hoje (#{I18n.l(@date)})")
#  end

#  def new_food(user, food)
#    @user = user
#    @food = food
#    mail(
#      :from => "#{user.name} <#{user.email}>",
#      :to => "Info ContaCal <sugestao@contacal.com.br>",
#      :subject => "Sugestão de novo alimento")
#  end

end