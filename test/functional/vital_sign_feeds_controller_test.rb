require 'test_helper'

class VitalSignFeedsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    @user = FactoryGirl.create(:user)
    @vsf = FactoryGirl.build(:vital_sign_feed)
    @feed_response_body = File.new("test/fixtures/sample_vital_signs.xml").read
    sign_in @user
  end
  
  test "without authorization" do
    post :create, {vital_sign_feed: {url: @vsf.url}, record_id: @vsf.record.medical_record_number}
    test_url = @vsf.vital_sign_host.authorization_request_url("http://test.host/vital_sign_callback/access_code").to_s
    assert_redirected_to test_url
    
    vsa =  @user.reload.vital_sign_auths.first
    assert_not_nil vsa
    assert_nil vsa.access_token
    assert_equal @vsf.url, vsa.vital_sign_feed.url
  end
  
  test "with authorization" do
    @vsf.save!
    @user.vital_sign_auths.create!(vital_sign_feed: @vsf, access_token: "asdfasdf")
    stub_request(:get, "http://#{@vsf.vital_sign_host.hostname}/vs1").
                with(:headers => {'Authorization'=>'Bearer asdfasdf'}).
                to_return(:status => 200, :body => @feed_response_body, :headers => {})
    
    
    post :create, {vital_sign_feed: {url: @vsf.url}, record_id: @vsf.record.medical_record_number}
    assert_redirected_to record_path(@vsf.record.medical_record_number)
    assert_equal 6, @vsf.record.reload.vital_signs.size
  end
end
