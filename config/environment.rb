# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
HdataServer::Application.initialize!

require_relative "../lib/hds/entry"
require_relative "../lib/hds/record"