source 'http://rubygems.org'

gem 'rails', '3.1.0'
gem "health-data-standards", :git => "http://github.com/ssayer/health-data-standards.git", :branch => "develop" 
gem "mongoid"
gem "bson_ext"
gem "pry"
gem "capistrano"
gem 'heroku'
gem "nokogiri"


group :assets do
  gem 'sass-rails', "  ~> 3.1.0"
  gem 'coffee-rails', "~> 3.1.0"
  gem 'uglifier'
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
end