require 'test_helper'

class VitalSignCallbackControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @user = FactoryGirl.create(:user)
    @vital_sign_feed = FactoryGirl.create(:vital_sign_feed)
    sign_in @user
  end
  
  test "should get access_code" do
    @user.vital_sign_auths << VitalSignAuth.new(vital_sign_feed: @vital_sign_feed)
    FakeWeb.register_uri(:get, "http://#{@vital_sign_feed.vital_sign_host.hostname}/authorize",
                         :body => '{
                           "access_token":"2YotnFZFEjr1zCsicMWpAA",
                           "token_type":"example",
                           "expires_in":3600,
                           "refresh_token":"tGzv3JOkF0XG5Qx2TlKWIA",
                           "example_parameter":"example_value"
                         }')
    get :access_code
    assert_response :redirect
    @user.reload
    assert_equal "2YotnFZFEjr1zCsicMWpAA", @user.vital_sign_auths.first.access_token
  end

end
