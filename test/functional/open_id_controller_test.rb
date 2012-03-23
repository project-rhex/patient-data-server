require 'test_helper'

class OpenIdControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    load_fixtures()
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  # Test authentication controller endpoints
  def test_authenticate
    redirect = 'http://foo'

    get :authorize, response_type: 'code', client_id: '1', scope: 'openid profile email',
        redirect_uri: redirect, nonce: '12141512544124', state: 123
    assert_response 200

    key = OpenIdController::OII + '1'
    svars = session[key]
    assert_not_nil svars[:redirect]
    assert_not_nil svars[:nonce]
    assert_not_nil svars[:state]
    assert_not_nil svars[:scope]
    assert_not_nil svars[:prompt]

    # Bad credentials
    get :validate, email: 'johnsmith@mitre.org', password: 'passwordx', client_id: 1
    assert_response 400

    # Good credentials
    get :validate, email: 'johnsmith@mitre.org', password: 'password', client_id: 1
    assert_response 200

    get :confirm, permit: 'on', email: 'on', profile: 'on', client_id: 1
    assert_response 302
    assert_not_nil response.headers['Location']
    assert_not_nil response.headers['Location'].index('code=')
    assert_not_nil response.headers['Location'].index('state=')
  end


  # Test various bad parameter cases
  def test_missing_and_bad_parameters
    redirect = 'http://foo'

    # Bad code
    get :authorize, response_type: 'xxxx', client_id: '1', scope: 'openid profile email',
      redirect_uri: redirect, nonce: '12141512544124', state: 123

    er = {value: "invalid_request", description: "Invalid or malformed request", state: 123}
    rurl = "http://foo?error=#{er[:value]}&error_description=#{er[:description]}&state=#{er[:state]}"
    assert_response 302
    assert_redirected_to rurl

    # Unknown client
    get :authorize, response_type: 'code', client_id: '2', scope: 'openid profile email',
          redirect_uri: redirect, nonce: '12141512544124', state: 123

    assert_response 302
    assert_redirected_to rurl

    # Missing openid in scope
    get :authorize, response_type: 'code', client_id: '1', scope: 'profile email',
          redirect_uri: redirect, nonce: '12141512544124', state: 123

    assert_response 302
    assert_redirected_to rurl

    # Missing nonce
    get :authorize, response_type: 'code', client_id: '1', scope: 'profile email openid',
          redirect_uri: redirect, state: 123

    assert_response 302
    assert_redirected_to rurl

    # Missing client id
    get :validate, permit: 'on', email: 'on'
    assert_response 400

    get :confirm, permit: 'on', email: 'on'
    assert_response 400
  end

  def test_missing_redirect
    # Missing redirect_uri returns 400 error
    get :authorize, response_type: 'code', client_id: '1', scope: 'profile email openid',
        state: 123

    assert_response 400
  end
end