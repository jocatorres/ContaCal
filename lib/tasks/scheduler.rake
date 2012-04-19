desc "This task is called by the Heroku scheduler add-on"

task :beginning_of_day => :environment do
  puts "Enviando mensagens diárias..."
  User.send_beginning_of_day_notification!
  puts "Fim das mensagens diárias."
  puts "Verificando se vai mandar resumo semanal."
  if Time.zone.now.wday == 1  
    puts "Enviando resumo semanal...."
    User.send_weekly_notification!
    puts "Fim do envio de resumo semanal."
  end
  puts "Fim da tarefa diária."
end

