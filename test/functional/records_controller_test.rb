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
  
  test "should generate a root.xml document based off the section mappings " do 
    @record = Factory.create(:record)
    get "root.xml", {record_id: @record.medical_record_number, id: @record.medical_record_number}
    assert_response :success
    
    doc = Nokogiri::XML::Document.parse(response.body)
    doc.root.add_namespace_definition('hrf', 'http://projecthdata.org/hdata/schemas/2009/06/core')
    

    root = doc.root
    assert_equal "root", root.name
    
    sr = SectionRegistry.instance

    sr.extensions.each do |e|
     ex_id = e.extension_id
     doc_ex = root.xpath("./hrf:extensions/hrf:extension[./text() = '#{ex_id}']")
     assert !doc_ex.empty?
     assert doc_ex.length == 1

     section = root.xpath("./hrf:sections/hrf:section[./@path='#{e.path}']")
     assert !section.empty?
     assert section.length == 1

     assert_equal doc_ex.first["./@id"], section.first["./@extensionId"]
    end
  end

  test "get records index Atom feed" do
    request.env['HTTP_ACCEPT'] = 'application/atom+xml'
    get :index
    assert_response :success
    assert_equal "application/atom+xml", response.content_type
    rss = Feedzirra::Feed.parse(@response.body)
    assert_not_nil(rss.entries)
    assert rss.entries.size > 0
  end

  test "get records show Atom feed" do
    request.env['HTTP_ACCEPT'] = 'application/atom+xml'
    get :show, :record_id => "4ebbd2717042f97ce200006c"
    assert_response :success
    assert_equal "application/atom+xml", response.content_type
    rss = Feedzirra::Feed.parse(@response.body)
    assert_not_nil(rss.entries)
    assert_equal(12, rss.entries.size)
  end
  
  def assert_not_nodeset(node)
    assert_not_equal node.class, Nokogiri::XML::NodeSet, "Nodeset not expected"
  end
end