require 'test_helper'
require 'feedzirra'
require 'open-uri'
require 'json_constants'
require "json"

class ResultsControllerTest < ActionController::TestCase

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
    # Create a bare record to work with, just borrowed data record from fixtures
    data = JSON.parse('{ "_id" : "4e57b6c04f85cffb1d000001", "first" : "Rhonda", "medical_record_number" : "1", "patient_id" : "5838337972", "last" : "Sparks", "gender" : "F", "birthdate" : -790874989, "addresses" : [ { "street" : [ "26 Park Street" ], "city" : "Burlington", "state" : "VT", "postalCode" : "05400" } ], "measures" : {}, "encounters" : [ { "codes" : { "CPT" : [ "99201" ] }, "time" : 1265256841, "description" : "Outpatient encounter" }, { "codes" : { "CPT" : [ "99201" ] }, "time" : 1287994563, "description" : "Outpatient encounter" }, { "codes" : { "CPT" : [ "99385" ] }, "time" : 1277523855, "description" : "Preventative encounter" } ], "conditions" : [ { "codes" : { "ICD-9-CM" : [ "401.0" ] }, "time" : 1266487005, "description" : "Hypertension" }, { "codes" : { "SNOMED-CT" : [ "105539002" ] }, "time" : 1267924277, "description" : "Tobacco Non-user" } ], "results" : [ { "codes" : { "SNOMED-CT" : [ "439958008" ] }, "time" : 1265256841, "description" : "Cervical cancer screening" } ], "vital_signs" : [ { "codes" : { "SNOMED-CT" : [ "12929001" ] }, "value" : { "scalar" : 146, "units" : "mmHg" }, "time" : 1287994563, "description" : "Systolic" }, { "codes" : { "SNOMED-CT" : [ "163031004" ] }, "value" : { "scalar" : 80, "units" : "mmHg" }, "time" : 1287994563, "description" : "Diastolic" }, { "codes" : { "SNOMED-CT" : [ "105539002" ] }, "time" : 1269363119, "description" : "Tobacco Non-user" }, { "codes" : { "SNOMED-CT" : [ "225171007" ] }, "value" : { "scalar" : 22, "units" : null }, "time" : 1264479406, "description" : "BMI" } ], "procedures" : [ { "codes" : { "SNOMED-CT" : [ "12389009" ] }, "time" : 1239540900, "description" : "Breast cancer screening" } ], "medications" : [ { "codes" : { "RxNorm" : [ "857924" ] }, "time" : 1265256841, "description" : "Influenza Vaccine" }, { "codes" : { "RxNorm" : [ "854931" ] }, "time" : 1265256841, "description" : "Pneumonia Vaccine" } ] }')
    Record.create(data)
  end

  # Called after every test method runs. Can be used to tear
  # down fixture information.

  def teardown
    Record.delete_all
  end

  # This is really punting on the multipart-form, but we're moving to a different controller solution where this
  # problem is being solved - so solving the issue here is duplicating effort
  def json_post name, id, hash
    id_part = id.to_s
    part = hash.to_json
    post(:add, :id => id_part.to_s, :content => {:content_data => part.to_s, :content_type => 'application/json' })
  end

  def test_get_atom_feed
    @request.accept="application/atom+xml"
    get(:index, :id => 1)
    rss = Feedzirra::Feed.parse(@response.body)
    assert_not_nil(rss.entries)
    assert_equal(1, rss.entries.size)
    assert rss.entries[0].links[0].include? "/records/1/results/1"
  end

  def test_get_content
    @request.accept="application/json"
    get(:show, :id => 1, :result_id => 1)
    content = @response.body
    assert_not_nil(content)
    fail if content.class != String
    json = JSON.parse(content)
    assert_not_nil(json[JsonConstants::CODES])
    assert_not_nil(json[JsonConstants::TIME])
    assert_not_nil(json[JsonConstants::DESCRIPTION])
  end

  def test_get_missing_content
    @request.accept="application/json"
    get(:show, :id => 1, :result_id => 3)
    content = @response.body
  end

  def test_post_content
    now = Time.now.to_i
    code_val = [ 19085718905 ]
    key = "SNOMED-CT"
    result = {
        JsonConstants::CODES => {
           key => code_val
        },
        JsonConstants::TIME => now,
        JsonConstants::DESCRIPTION => "cbc neutrophils",
        JsonConstants::VALUE => {
            JsonConstants::SCALAR => 2500,
            JsonConstants::UNITS => "count"
        }
    }
    json_post :add, 1, result
    record = Record.first(conditions: {medical_record_number: 1})
    assert_not_nil record
    assert_not_nil record.results
    assert_equal 2, record.results.size
    result_2 = record.results[1]

    assert_equal now, result_2[JsonConstants::TIME]

    codes = result_2[JsonConstants::CODES]
    assert_not_nil codes
    code = codes[key]
    assert_not_nil code
    assert_equal code_val, code

    assert_equal "cbc neutrophils", result_2[JsonConstants::DESCRIPTION]

    value = result_2[JsonConstants::VALUE]
    assert_not_nil value
    assert_equal 2500, value[JsonConstants::SCALAR]
    assert_equal 'count', value[JsonConstants::UNITS]
  end

end