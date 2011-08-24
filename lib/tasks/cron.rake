namespace :notification do
  task :beginning_of_day => :environment do
    User.send_beginning_of_day_notification!
  end

  task :end_of_day => :environment do
    User.send_end_of_day_notification!
  end
end

task :cron => :environment do
  return false
  if false
    Rake::Task['notification:beginning_of_day'].invoke
  end
  if false
    Rake::Task['notification:end_of_day'].invoke
  end
end