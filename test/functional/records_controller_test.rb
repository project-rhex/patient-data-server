require 'test_helper'

class RecordsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  test 'create' do
    start_record_count = Record.count
    c32_file = File.read(Rails.root.join('test/fixtures/Henry_Smith_44.xml'))
    request.env['RAW_POST_DATA'] = c32_file
    request.env['CONTENT_TYPE'] = 'application/xml'

    post :create

    assert_response 201
    assert_equal (start_record_count + 1), Record.count
    assert response['Location'].present?
    assert response['Location'].include? "4ebbd2717042f97ce200006c" # ID for Henry declared in the C32
  end

  test "breadcrumbs" do
    assert_equal([{ :title => "Home", :link => "/"}, { :title => 'Patient Index'}], @controller.breadcrumbs)
  end
end