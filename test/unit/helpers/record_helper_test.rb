require 'test_helper'

class RecordHelperTest < ActionView::TestCase
  test "record_simple_value" do
    assert_equal "<div class='simple_value'>foobar</div>", record_simple_value("foobar")
  end

  test "patient_name" do
    rec = FactoryGirl.create(:record)
    assert_equal "<span id='patient_name'>Doe,&nbsp;John</span>",  patient_name(rec)
  end

  test "section_enumerator" do
    rec = FactoryGirl.create(:record)
    rec[:results] = [ FactoryGirl.create(:lab_result) ]
    i = 0
    section_enumerator(rec, :results, (Time.now - 3000000000)) do |x|
      i += 1
    end
    assert i > 0
  end

  test "most_recent_vital_date" do
    rec = FactoryGirl.create(:record)
    now = Time.now
    vs1 = FactoryGirl.create(:lab_result)
    vs1.time = now.to_i
    vs1.description = 'bmi'
    vs2 = FactoryGirl.create(:lab_result)
    vs2.time = now.to_i - 10000
    vs2.description = 'bmi'
    vs3 = FactoryGirl.create(:lab_result)
    vs3.description = 'bmi'
    rec.vital_signs.concat([ vs1, vs2, vs3 ])
    time = most_recent_vital_date rec
    assert_equal 0, now.to_i - time.to_i
  end

  test "most_recent_vital" do
    rec = FactoryGirl.create(:record)
    now = Time.now
    vs1 = FactoryGirl.create(:lab_result)
    vs1.time = now.to_i
    vs2 = FactoryGirl.create(:lab_result)
    vs2.time = now.to_i - 10000
    vs3 = FactoryGirl.create(:lab_result)
    rec.vital_signs.concat([ vs1, vs2, vs3 ])
    v = latest_matching_vital rec, 'ldl'
    assert_equal "127 mg/dL", v
  end
end