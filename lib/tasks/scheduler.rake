desc "This task is called by the Heroku scheduler add-on"
task :weekly => :environment do
  User.send_weekly_notification!
end

task :beginning_of_day => :environment do
  User.send_beginning_of_day_notification!
end

