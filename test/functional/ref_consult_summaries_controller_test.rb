require 'test_helper'

class RefConsultSummariesControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  
  setup do
    @request.env["devise.mapping"] = Devise.mappings
    @user = FactoryGirl.create(:user)
    sign_in @user
    
    @ref_consult_summary = FactoryGirl.create(:ref_consult_summary)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ref_consult_summaries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ref_consult_summary" do
    r = Factory.attributes_for(:ref_consult_summary)

    assert_difference('RefConsultSummary.count') do
      post :create, ref_consult_summary: r
    end

    assert_redirected_to ref_consult_summary_path(assigns(:ref_consult_summary))
  end

  test "should show ref_consult_summary" do
    get :show, id: @ref_consult_summary
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @ref_consult_summary
    assert_response :success
  end

  test "should update ref_consult_summary" do
    put :update, id: @ref_consult_summary, ref_consult_summary: @ref_consult_summary.attributes
    assert_redirected_to ref_consult_summary_path(assigns(:ref_consult_summary))
  end

  test "should destroy ref_consult_summary" do
    assert_difference('RefConsultSummary.count', -1) do
      delete :destroy, id: @ref_consult_summary
    end

    assert_redirected_to ref_consult_summaries_path
  end
end
