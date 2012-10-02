require 'test_helper'

class VitalSignHostsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  setup do
    @user = FactoryGirl.create(:user)
    @vital_sign_host = FactoryGirl.create(:vital_sign_host)
    sign_in @user
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vital_sign_hosts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create vital_sign_host" do
    assert_difference('VitalSignHost.count') do
      post :create, vital_sign_host: { client_id: @vital_sign_host.client_id, client_secret: @vital_sign_host.client_secret, hostname: @vital_sign_host.hostname }
    end

    assert_redirected_to vital_sign_host_path(assigns(:vital_sign_host))
  end

  test "should show vital_sign_host" do
    get :show, id: @vital_sign_host
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @vital_sign_host
    assert_response :success
  end

  test "should update vital_sign_host" do
    put :update, id: @vital_sign_host, vital_sign_host: { client_id: @vital_sign_host.client_id, client_secret: @vital_sign_host.client_secret, hostname: @vital_sign_host.hostname }
    assert_redirected_to vital_sign_host_path(assigns(:vital_sign_host))
  end

  test "should destroy vital_sign_host" do
    assert_difference('VitalSignHost.count', -1) do
      delete :destroy, id: @vital_sign_host
    end

    assert_redirected_to vital_sign_hosts_path
  end
end
