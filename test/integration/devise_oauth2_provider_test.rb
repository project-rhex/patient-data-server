require 'test_helper'

# This is just some simple testing to see that devise is configured with the OAUTH2 provider
# We are not testing the entirty of the provider, we are counting on the tests for that to cover that
# it works.  We are only testing here that it is configured
class DeviseOauth2ProviderTest <  ActionController::TestCase
  include Devise::TestHelpers
  setup do
    Devise::Oauth2Providable::Client.destroy_all
    @controller = Devise::Oauth2Providable::AuthorizationsController.new
    @record = FactoryGirl.create(:record, :with_lab_results)
    @user = FactoryGirl.create(:user)
    @client = FactoryGirl.create(:client)
    sign_in @user
  end
  
  test "Should Redirect to client URL without an auth token " do

    get :new, :client_id => @client.cidentifier, :redirect_uri => @client.redirect_uri, :response_type => 'code', :use_route => 'devise_oauth2_providable'
    assert_response :success
  end
  
  test "Should return error with bad redirect utl  " do
    get :new, :client_id => @client.cidentifier, :redirect_uri => "#{@client.redirect_uri}/t", :response_type => 'code', :use_route => 'devise_oauth2_providable'
    assert_response 400, "Should respond with error message if redirect does not match uri"
  end
end
