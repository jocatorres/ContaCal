require "bundler/capistrano"

set :whenever_command, "bundle exec whenever"
require "whenever/capistrano" 

#APP SETTINGS
set :application, "contacal.com.br"

# GIT SETTINGS
set :scm, :git
set :repository,  "git@github.com:jocatorres/ContaCal.git"
set :branch, "newcloud"
#set :scm_username, "git"
#set :scm_password, "git"

# SSH SETTINGS
set :user , "deploy"
set :password, "d^7!Uy10"
set :use_sudo, true
set :group_writable, false
default_run_options[:pty] = true

def show_prompt(env)
  # Prompt to make really sure we want to deploy into prouction
  puts "\n\e[0;31m   ######################################################################"
  puts "   #\n   #       Are you REALLY sure you want to #{env} to production?"
  puts "   #\n   #               Enter y/n + enter to continue\n   #"
  puts "   ######################################################################\e[0m\n"
  proceed = STDIN.gets[0..0] rescue nil
  exit unless proceed == 'y' || proceed == 'Y'  
  
end

task :production do
  set :domain_name, "186.202.117.20"
  # ROLES
  role :web, domain_name  
  role :app, domain_name
  role :db,  domain_name, :primary => true  
  set :deploy_to,  "/var/www/contacal.com.br"
  set :shared_directory, "#{deploy_to}/shared"  
  
  set :deploy_via, :remote_cache
  # after('deploy:symlink', 'cache:clear')
end

task :beta do
  set :domain_name, "beta.contacal.com.br"
  # ROLES
  role :web, domain_name  
  role :app, domain_name
  role :db,  domain_name, :primary => true  
  set :deploy_to,  "/var/www/beta.contacal.com.br"
  set :shared_directory, "#{deploy_to}/shared"  
  
  set :deploy_via, :remote_cache
  # after('deploy:symlink', 'cache:clear')
end

#TASKS
task :after_update_code, :roles => [:web, :db, :app] do
  run "chmod 755 #{release_path}/public"
  db.create_database_yaml
end

namespace :deploy do
  # Restart passenger on deploy
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    after_update_code
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  
  namespace :web do
    task :disable, :roles => :web do
      on_rollback { rm "#{shared_path}/system/maintenance.html" }

      require 'erb'
      deadline, reason = ENV['UNTIL'], ENV['REASON']
      maintenance = ERB.new(File.read("./app/views/layouts/maintenance.html.erb")).result(binding)

      put maintenance, "#{shared_path}/system/maintenance.html", :mode => 0644
    end
  end  
end

namespace :db do

  desc "create database.yml"
  task :create_database_yaml do
    run "ln -s #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  
  desc "link sqlite db"
  task :link_sql_lite do
    run "ln -s #{shared_path}/db/production.sqlite3 #{release_path}/db/production.sqlite3"
  end  

end
