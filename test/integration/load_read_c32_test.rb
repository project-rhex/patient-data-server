require 'test_helper'
include Devise::TestHelpers

class LoadReadC32Test < ActionController::TestCase


  setup do
    @request.env["devise.mapping"] = Devise.mappings
    @user = FactoryGirl.create(:user)
    sign_in @user
    ## clean out Record table
    ##STDOUT << "\nClearing Record Table\n"
    Record.all.each {|x| x.destroy}
  end


  test "c32_read" do
    ## precondition - need audit log table empty
    record = Record.all.first
    assert_nil record, "Record precondition FAIL - record table is NOT empty!"

    ## read C32 from XML file
    doc = Nokogiri::XML(File.read(File.dirname(__FILE__) + "/../fixtures/Henry_Smith_44.xml")) #Johnny_Smith_96.xml'))
    doc.root.add_namespace_definition('cda', 'urn:hl7-org:v3')
    pi = HealthDataStandards::Import::C32::PatientImporter.instance

    patient = pi.parse_c32(doc)
    assert_not_nil patient, "Patient record is nil !"
    ##STDOUT << "****** patient"
    ##STDOUT << patient.inspect

    ##puts "****** allergies"
    ##puts patient.allergies.inspect
    assert_not_nil patient.allergies, "Patient patient.allergies is nil !"
=begin
    puts "****** care goals"
    puts patient.care_goals.inspect
    assert_not_nil patient.care_goals, "Patient patient.care_goals is nil !"

    puts "****** conditions"
    puts patient.conditions.inspect
    assert_not_nil patient.conditions, "Patient patient.conditions is nil !"

    puts "****** encounters"
    puts patient.encounters.inspect
    assert_not_nil patient.encounters, "Patient patient.encounters is nil !"

    puts "****** immunizations"
    puts patient.immunizations.inspect
    assert_not_nil patient.immunizations, "Patient patient.immunizations is nil !"

    puts "****** medical equip"
    puts patient.medical_equipment.inspect
    assert_not_nil patient.medical_equipment, "Patient patient.medical_equipment is nil !"

    puts "****** medications"
    puts patient.medications.inspect
    assert_not_nil patient.medications, "Patient patient.medications is nil !"

    puts "****** procedures"
    puts patient.procedures.inspect
    assert_not_nil patient.procedures, "Patient patient.procedures is nil !"

    puts "****** results"
    puts patient.results.inspect
    assert_not_nil patient.results, "Patient patient.results is nil !"

    puts "****** social history"
    puts patient.social_history.inspect
    assert_not_nil patient.social_history, "Patient patient.social_history is nil !"

    puts "****** vital signs"
    puts patient.vital_signs.inspect
    assert_not_nil patient.vital_signs, "Patient patient.vital_signs is nil !"
=end
    ## save as JSON
    patient.save
    assert_not_nil patient, "Patient record is empty"

    ## read as JSON and output
    record = Record.first
    #STDOUT << record.inspect
    #record.update_attribute(:medical_record_number, 1)
    assert_equal record.last, "Smith44"

  end


end

