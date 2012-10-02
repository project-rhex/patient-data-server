require 'test_helper'
require 'atom_test'

class EntriesControllerTest < AtomTest
  include Devise::TestHelpers
  
  setup do
    @record = FactoryGirl.create(:record, :with_lab_results)
    @user = FactoryGirl.create(:user)
    sign_in @user
  end
  
  test "get a result as xml" do
    request.env['HTTP_ACCEPT'] = Mime::XML
    get :show, {record_id: @record.medical_record_number, section: 'results', id: @record.results.first.id}
    doc = Nokogiri::XML::Document.parse(response.body)
    assert_response :success
    assert_equal "result", doc.children.first.name
  end
  
  test "get a result as JSON" do
    request.env['HTTP_ACCEPT'] = Mime::JSON
    get :show, {record_id: @record.medical_record_number, section: 'results', id: @record.results.first.id}
    doc = JSON.parse(response.body)
    assert_response :success
    assert_equal "LDL Cholesterol", doc['description']
  end
  
  test "get a section that doesn't exist" do
    request.env['HTTP_ACCEPT'] = Mime::XML
    get :show, {record_id: @record.medical_record_number, section: 'bacon', id: @record.results.first.id}
    assert_response :missing
  end
  
  test "get section Atom feed" do
    request.env['HTTP_ACCEPT'] = 'application/atom+xml'
    get :index, {record_id: @record.medical_record_number, section: 'results'}
    assert_response :success
    assert_atom_success
    rss = atom_results
    assert_atom_result_count rss, 1
    assert rss.entries[0].links[0].include? "/records/#{@record.medical_record_number}/results/#{@record.results.first.id}"
  end
  
  test "post a new result section document" do
    assert_equal 1, @record.results.count
    result_file = File.read(Rails.root.join('test/fixtures/result.xml'))
    request.env['RAW_POST_DATA'] = result_file
    request.env['CONTENT_TYPE'] = 'application/xml'
    post :create, {record_id: @record.medical_record_number, section: 'results'}
    assert_response 201
    assert response['Location'].present?
    @record.reload
    assert_equal 2, @record.results.count
    result = @record.results[1]
    assert_equal 135, result.values.first.scalar
  end
  
  test "update a lab result" do
    result_file = File.read(Rails.root.join('test/fixtures/result.xml'))
    result = @record.results.first
    request.env['RAW_POST_DATA'] = result_file
    request.env['CONTENT_TYPE'] = 'application/xml'
    put :update, {record_id: @record.medical_record_number, section: 'results', id: result.id}
    assert_response :success
    result.reload
    assert_equal 135, result.values.first.scalar
  end

  test "delete a result" do
    assert_equal 1, @record.results.count
    delete :delete, {record_id: @record.medical_record_number, section: 'results', id: @record.results.first.id}
    assert_response 204
    @record.reload
    assert_equal 0, @record.results.count
  end
  
  test "get a document that doesn't exist" do
    request.env['HTTP_ACCEPT'] = Mime::XML
    get :show, {record_id: @record.medical_record_number, section: 'results', id: 'bacon'}
    assert_response 404
    
    get :show, {record_id: @record.medical_record_number, section: 'results', id: ('0' * 24)}
    assert_response :missing
  end

  test "check for 404 on non-existent record on index" do
    get :index, :record_id => "AAAA"
    assert_response :missing
  end

  test "check for 404 on non-existent record on show" do
    get :show, :record_id => "AAAA"
    assert_response :missing
  end

  test "check for 404 on non-existent record on update" do
    get :update, :record_id => "AAAA"
    assert_response :missing
  end

  test "check for 404 on non-existent record on delete" do
    get :delete, :record_id => "AAAA"
    assert_response :missing
  end
  

end