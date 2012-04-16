require 'test_helper'
include Devise::TestHelpers

class LoadReadC32Test < ActionController::TestCase


  setup do
    @request.env["devise.mapping"] = Devise.mappings
    @user = FactoryGirl.create(:user)
    sign_in @user
    ## clean out Record table
    Record.all.each {|x| x.destroy}
  end


  test "c32_read" do
    ## precondition - need audit log table empty
    record = Record.all.first
    assert_nil record, "Record precondition FAIL - record table is NOT empty!"

    ## read C32 from XML file
    doc = Nokogiri::XML(File.read(File.dirname(__FILE__) + "/../fixtures/Henry_Smith44.xml")) #Johnny_Smith_96.xml'))
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    pi = HealthDataStandards::Import::C32::PatientImporter.instance

    patient = pi.parse_c32(doc)
    assert_not_nil patient, "Patient record is nil !"

    assert_not_nil patient.allergies, "Patient patient.allergies is nil !"

    ## save as JSON
    patient.save
    assert_not_nil patient, "Patient record is empty"

    ## read as JSON and output
    record = Record.first
    
    assert_equal record.last, "Smith44"

  end


end

