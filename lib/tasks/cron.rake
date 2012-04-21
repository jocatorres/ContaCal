namespace :notification do
  task :weekly => :environment do
    User.send_weekly_notification!
  end

  task :beginning_of_day => :environment do
    User.send_beginning_of_day_notification!
  end
end

task :cron => :environment do
  if Time.zone.now.hour == 6 && Time.zone.now.wday == 1
    Rake::Task['notification:weekly'].invoke
  end

  if Time.zone.now.hour == 8
    Rake::Task['notification:beginning_of_day'].invoke
  end
end