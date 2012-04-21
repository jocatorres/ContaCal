desc "This task is called by the Heroku scheduler add-on"

task :beginning_of_day => :environment do
#  User.send_beginning_of_day_notification!
  User.send_beginning_of_day_notification
  if Time.zone.now.wday == 1  
    User.send_weekly_notification!
  end
end

