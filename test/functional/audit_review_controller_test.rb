require 'test_helper'

class AuditReviewControllerTest < ActionController::TestCase
  include Devise::TestHelpers

   setup do
    @request.env["devise.mapping"] = Devise.mappings
    @user = FactoryGirl.create(:user)
    sign_in @user

    records = FactoryGirl.create_list(:record, 2)
    @record = records.first

  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

end
