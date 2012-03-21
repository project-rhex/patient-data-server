require 'test_helper'

class ClientsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    Devise::Oauth2Providable::Client.destroy_all
    @client = FactoryGirl.create(:client)
    @request.env["devise.mapping"] = Devise.mappings
    @user = FactoryGirl.create(:user)
    sign_in @user
  end
  
  test "get" do
    get :show, id: @client.id
    assert_response :success
  end
  

  test "should get edit" do
    get :edit, id: @client.id
    assert_response :success
  end
  
  test "create" do
    assert_difference('Devise::Oauth2Providable::Client.count') do
      post :create, client: {name: 'Test-o-matic', redirect_uri: 'http://foo.com/callback', website: 'http://foo.com'}
    end
    
    assert_redirected_to client_path(assigns(:client))
  end
  
  test "update" do
    post :update, id: @client.id, client: {name: 'Test-o-matic', redirect_uri: 'http://foo.com/callback', website: 'http://foo.com'}
    assert_redirected_to client_path(assigns(:client))
    assert_equal 'Test-o-matic', assigns(:client).name
  end
  
  test "destroy" do
    delete :destroy, id: @client.id
    assert_equal 0, Devise::Oauth2Providable::Client.count
  end
end
