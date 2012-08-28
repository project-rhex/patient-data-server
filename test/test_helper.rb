ENV["RAILS_ENV"] = "test"
require 'cover_me'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/test_unit'

class ActiveSupport::TestCase
  
  def load_fixtures
    `mongoimport -d #{Mongoid.master.name} -h #{Mongoid.master.connection.host_to_try[0]} --drop -c records test/fixtures/records.json`
    `mongoimport -d #{Mongoid.master.name} -h #{Mongoid.master.connection.host_to_try[0]} --drop -c users test/fixtures/users.json`
    `mongoimport -d #{Mongoid.master.name} -h #{Mongoid.master.connection.host_to_try[0]} --drop -c clients test/fixtures/clients.json`
  end
  

end


def dump_database
   Mongoid::Config.master.collections.each do |collection|
     collection.drop unless collection.name.include?('system.')
   end
end

dump_database