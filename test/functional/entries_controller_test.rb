require 'test_helper'

class EntriesControllerTest < ActionController::TestCase
  setup do
    @record = FactoryGirl.create(:record, :with_lab_results)
  end
  
  test "get a result as xml" do
    request.env['HTTP_ACCEPT'] = Mime::XML
    get :show, {record_id: @record.medical_record_number, section: 'results', id: @record.results.first.id}
    doc = Nokogiri::XML::Document.parse(response.body)
    assert_response :success
    assert_equal "result", doc.children.first.name
  end
  
  test "get a section that doesn't exist" do
    request.env['HTTP_ACCEPT'] = Mime::XML
    get :show, {record_id: @record.medical_record_number, section: 'bacon', id: @record.results.first.id}
    assert_response :missing
  end
  
  test "get a document that doesn't exist" do
    request.env['HTTP_ACCEPT'] = Mime::XML
    get :show, {record_id: @record.medical_record_number, section: 'results', id: 'bacon'}
    assert_response 400
    
    get :show, {record_id: @record.medical_record_number, section: 'results', id: ('0' * 24)}
    assert_response :missing
  end
end