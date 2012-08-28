source 'http://rubygems.org'


gem 'rails', '3.2.8'
gem "health-data-standards", :git => "http://github.com/projectcypress/health-data-standards.git", :branch => "develop"
gem 'ruby-openid', :git => 'https://github.com/rdingwell/ruby-openid.git',:branch => "master" 
gem "mongoid"
gem "bson_ext"
gem "pry"
gem 'pry-nav'
gem "capistrano"
gem 'heroku'
gem "nokogiri"
gem 'devise'
gem 'devise_oauth2_providable', :git => 'https://github.com/rdingwell/devise_oauth2_providable.git',:branch => "master" 

gem 'omniauth'
gem 'omniauth-openid'
gem 'kaminari'
gem "symbolize", :require => "symbolize/mongoid"

group :assets do
  gem 'sass-rails', "  ~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', ">= 1.0.3"
end

gem 'jquery-rails'

group :production do
  gem "therubyracer"
  gem 'thin'
end


group :test do
  gem 'turn', :require => false
  gem 'minitest'
  gem 'feedzirra'
  gem 'cover_me'
  gem 'factory_girl_rails'
  gem 'webmock'
end
