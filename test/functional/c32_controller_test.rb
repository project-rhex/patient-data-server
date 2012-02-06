require 'test_helper'

class C32ControllerTest < ActionController::TestCase

  setup do
    records = FactoryGirl.create_list(:record, 25)
    @record = records.first
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
end
