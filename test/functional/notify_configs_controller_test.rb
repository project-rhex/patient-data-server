require 'test_helper'

class NotifyConfigsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @request.env["devise.mapping"] = Devise.mappings
    @user = FactoryGirl.create(:user)
    sign_in @user
    @notify_config = FactoryGirl.create(:notify_config)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:notify_configs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create notify_config" do
    n = Factory.attributes_for(:notify_config)

    assert_difference('NotifyConfig.count') do
      post :create, notify_config: n
    end

    assert_redirected_to notify_config_path(assigns(:notify_config))
  end


  test "should show notify_config" do
    get :show, id: @notify_config
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @notify_config
    assert_response :success
  end

  test "should update notify_config" do
    put :update, id: @notify_config, notify_config: @notify_config.attributes
    assert_redirected_to notify_config_path(assigns(:notify_config))
  end

  test "should destroy notify_config" do
    assert_difference('NotifyConfig.count', -1) do
      delete :destroy, id: @notify_config
    end

    assert_redirected_to notify_configs_path
  end
end
