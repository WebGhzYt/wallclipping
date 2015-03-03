set :application, "Relayfan"
set :repository,  "http://www.stickygit.com/heresy/Relayfan.git"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "192.168.0.103"                          # Your HTTP server, Apache/etc
set :deploy_to, "/home/bhanu"
role :app, "192.168.0.103"                          # This may be the same as your `Web` server
default_run_options[:pty] = true
set :user, "bhanu"
set :deploy_via, :copy

# if you want to clean up old releases on each deploy uncomment this:
# after "deploy:restart", "deploy:cleanup"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end