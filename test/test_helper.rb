ENV["RAILS_ENV"] = "test"
require 'cover_me'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  
  def load_fixtures
    `mongoimport -d #{Mongoid.master.name} -h #{Mongoid.master.connection.host_to_try[0]} --drop -c records test/fixtures/records.json`
  end
  
end
