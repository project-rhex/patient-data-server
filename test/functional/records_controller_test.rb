require 'test_helper'
require 'atom_test'

class RecordsControllerTest < AtomTest
  include Devise::TestHelpers
  ROOT_SCHEMA = File.expand_path("../../xsd/root.xsd",__FILE__)
  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  test 'create' do
    start_record_count = Record.count
    c32_file = File.read(Rails.root.join('test/fixtures/Henry_Smith44.xml'))
    request.env['RAW_POST_DATA'] = c32_file
    request.env['CONTENT_TYPE'] = 'application/xml'

    post :create

    assert_response 201
    assert_equal (start_record_count + 1), Record.count
    assert response['Location'].present?
    assert response['Location'].include? "4f4e6eb7069d454d16000001" # ID for Henry declared in the C32
  end

  test "options" do
    process(:options, {:record_id => "4f4e6eb7069d454d16000001"}, nil, nil, 'OPTIONS')
    assert_response :success
    assert response.body.blank?
    assert response['X-hdata-security'] = 'http://openid.net/connect/'
    assert_equal SectionRegistry.instance.extensions.size, response['X-hdata-extensions'].split(' ').size
  end

  test "breadcrumbs" do
    assert_equal([{ :title => "Home", :link => "/"}, { :title => 'Patient Index'}], @controller.breadcrumbs)
  end
  
  test "should generate a root.xml document based off the section mappings " do 
    @record = Factory.create(:record)
    get "root.xml", {record_id: @record.medical_record_number, id: @record.medical_record_number}
    assert_response :success
    
    doc = Nokogiri::XML::Document.parse(response.body)
    

    
    xsd = Nokogiri::XML::Schema(open(ROOT_SCHEMA))
    assert_equal [], xsd.validate(doc)
    
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
    assert_atom_success
    rss = atom_results
    assert_atom_results rss
  end

  test "get records show Atom feed" do
    request.env['HTTP_ACCEPT'] = 'application/atom+xml'
    do_show_atom_feed "4f4e6eb7069d454d16000001", 12
  end

  test "get records show Atom feed (no accepts header)" do
    do_show_atom_feed "4f4e6eb7069d454d16000001", 12
  end

  test "check for 404 on non-existent record on show" do
    get :show, :record_id => "AAAA"
    assert_response :missing
  end

  test "check for 404 on non-existent record on root.xml" do
    get "root.xml", :record_id => "BBBB"
    assert_response :missing
  end

  def do_show_atom_feed id, count
    get :show, :record_id => id
    assert_atom_success
    rss = atom_results
    assert_atom_result_count rss, count
  end

  def assert_not_nodeset(node)
    assert_not_equal node.class, Nokogiri::XML::NodeSet, "Nodeset not expected"
  end
end
