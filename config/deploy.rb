$:.unshift(File.expand_path("~/.rvm/lib"))
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.2'
set :rvm_type, :user

set :scm, :git
set :scm_username, "ssayer"
set :repository,  "set your repository location here"
set :branch, "master"

set :application, "hdata"
role :web, "zoidberg"                 
role :app, "zoidberg"                   
role :db,  "zoidberg", :primary => true 

set :deploy_to, "/var/www/hdata"
set :deploy_via, :remote_cache