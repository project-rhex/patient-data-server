require 'test_helper'

class C32ControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    records = FactoryGirl.create_list(:record, 25)
    @record = records.first
    @request.env["devise.mapping"] = Devise.mappings
    @user = FactoryGirl.create(:user)
    sign_in @user
   
  end

  test "get c32 as xml" do
    request.env['HTTP_ACCEPT'] = Mime::XML
    get :show, {record_id: @record.medical_record_number, id: @record.medical_record_number}
    doc = Nokogiri::XML::Document.parse(response.body)
    assert_response :success
    assert_equal "ClinicalDocument", doc.children.first.name
    
  end
  
  test "get c32 as json" do
    request.env['HTTP_ACCEPT'] = Mime::JSON
    get :show, {record_id: @record.medical_record_number, id: @record.medical_record_number}
    assert_response :success
    
    result = ActiveSupport::JSON.decode(response.body)
    
    assert_equal @record.medical_record_number, result['medical_record_number']
  end

  test "get c32 index Atom feed" do
    request.env['HTTP_ACCEPT'] = 'application/atom+xml'
    get :index, :record_id => @record.medical_record_number
    assert_response :success
    assert_equal "application/atom+xml", response.content_type
    rss = Feedzirra::Feed.parse(@response.body)
    assert_not_nil(rss.entries)
    assert_equal(1, rss.entries.size)
    assert rss.entries[0].links[0].include? "/records/#{@record.medical_record_number}/c32/#{@record.medical_record_number}"
  end
end
