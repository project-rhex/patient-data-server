require "bundler/capistrano"

set :scm, :git
# set :scm_username, "ssayer"
set :repository,  "git://barrel.mitre.org/hdata-patient-server/hdata-patient-server.git"
set :branch, "master"

set :application, "hdata"
role :web, "zoidberg"                 
role :app, "zoidberg"                   
role :db,  "zoidberg", :primary => true 

default_run_options[:pty] = true
# ssh_options[:forward_agent] = true

set :deploy_to, "/var/www/hdata"
set :deploy_via, :remote_cache