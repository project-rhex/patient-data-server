require 'test_helper'

module ApplicationHelper
  def self.controller= value
    @controller = value
  end

  def controller
    @controller
  end
end

class RecordControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  include ApplicationHelper
  include RecordHelper

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
     @request.env["devise.mapping"] = Devise.mappings
     @user = FactoryGirl.create(:user)
     sign_in @user
    # Create a bare record to work with, just borrowed data record from fixtures
    data = JSON.parse('{ "_id" : "4e57b6c04f85cffb1d000001", "first" : "Rhonda", "medical_record_number" : "1", "patient_id" : "5838337972", "last" : "Sparks", "gender" : "F", "birthdate" : -790874989, "addresses" : [ { "street" : [ "26 Park Street" ], "city" : "Burlington", "state" : "VT", "postalCode" : "05400" } ], "measures" : {}, "encounters" : [ { "codes" : { "CPT" : [ "99201" ] }, "time" : 1265256841, "description" : "Outpatient encounter" }, { "codes" : { "CPT" : [ "99201" ] }, "time" : 1287994563, "description" : "Outpatient encounter" }, { "codes" : { "CPT" : [ "99385" ] }, "time" : 1277523855, "description" : "Preventative encounter" } ], "conditions" : [ { "codes" : { "ICD-9-CM" : [ "401.0" ] }, "time" : 1266487005, "description" : "Hypertension" }, { "codes" : { "SNOMED-CT" : [ "105539002" ] }, "time" : 1267924277, "description" : "Tobacco Non-user" } ], "results" : [ { "codes" : { "SNOMED-CT" : [ "439958008" ] }, "time" : 1265256841, "description" : "Cervical cancer screening" } ], "vital_signs" : [ { "codes" : { "SNOMED-CT" : [ "12929001" ] }, "value" : { "scalar" : 146, "units" : "mmHg" }, "time" : 1287994563, "description" : "Systolic" }, { "codes" : { "SNOMED-CT" : [ "163031004" ] }, "value" : { "scalar" : 80, "units" : "mmHg" }, "time" : 1287994563, "description" : "Diastolic" }, { "codes" : { "SNOMED-CT" : [ "105539002" ] }, "time" : 1269363119, "description" : "Tobacco Non-user" }, { "codes" : { "SNOMED-CT" : [ "225171007" ] }, "value" : { "scalar" : 22, "units" : null }, "time" : 1264479406, "description" : "BMI" } ], "procedures" : [ { "codes" : { "SNOMED-CT" : [ "12389009" ] }, "time" : 1239540900, "description" : "Breast cancer screening" } ], "medications" : [ { "codes" : { "RxNorm" : [ "857924" ] }, "time" : 1265256841, "description" : "Influenza Vaccine" }, { "codes" : { "RxNorm" : [ "854931" ] }, "time" : 1265256841, "description" : "Pneumonia Vaccine" } ] }')
    Record.create(data)
  end

  test "breadcrumbs" do
    assert_equal([{ :title => "Home", :link => "/"}, { :title => 'Patient Index'}], @controller.breadcrumbs)
  end

  test "calculate_age" do
    ApplicationHelper::controller = @controller
    day_in_seconds = 24 * 3600
    today = Time.now
    assert_equal "less than a day", calculate_age(today)

    yesterday = today - day_in_seconds
    assert_equal "1 day", calculate_age(yesterday)

    two_days = today - (2 * day_in_seconds)
    assert_equal "2 days", calculate_age(two_days)

    last_month = today - (32 * day_in_seconds)
    assert_equal "1 month", calculate_age(last_month)

    two_months = today - (64 * day_in_seconds)
    assert_equal "2 months", calculate_age(two_months)

    one_year = today - (366 * day_in_seconds)
    assert_equal "1 year", calculate_age(one_year)

    two_years = today - (740 * day_in_seconds)
    assert_equal "2 years", calculate_age(two_year)
  end

  test "record_simple_value" do
    assert_equal "<div class='simple_value'>foobar</div>", record_simple_value("foobar")
  end

  test "patient_name" do
    @record = Record.first(conditions: {medical_record_number: 1})
    assert_equal "<span id='patient_name'>Sparks,&nbsp;Rhonda</span>",  patient_name
  end
end