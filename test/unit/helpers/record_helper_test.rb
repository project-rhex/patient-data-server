require 'test_helper'
require 'ostruct'

class RecordHelperTest < ActionView::TestCase
  test "section_enumerator" do
    rec = FactoryGirl.create(:record, :with_lab_results)
    r2 = FactoryGirl.create(:lab_result)
    r2.time = Time.now.to_i
    rec.results << r2
    i = 0
    section_enumerator(rec, :results) do |x|
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
    assert_equal "<span class='lab_value'>127 (mg/dL)</span>", v

    v = latest_matching_vital rec, 'xyz'
    assert_equal "", v
  end

  test "most recent vital date with none" do
    rec = FactoryGirl.create(:record)
    time = most_recent_vital_date rec
    assert_nil time
  end

  test "sex method" do
    rec = FactoryGirl.create(:record)
    assert_equal "Male", sex(rec)
  end

  test "format a value" do
    r = FactoryGirl.create(:lab_result)
    assert_equal "<span class='lab_value'>127 (mg/dL)</span>", show_value(r.values.first)
  end

  test "format a value 2" do
    assert_equal "<span class='lab_value'>127</span>", show_value(OpenStruct.new('scalar' => 127))
  end

  test "format a value 3" do
    assert_equal "<span class='lab_value'>127.12</span>", show_value(OpenStruct.new('scalar' => 127.12345))
  end

  test "format a value 4" do
    assert_equal "<span class='lab_value'>127.12</span>", show_value(OpenStruct.new('scalar' => "127.12345"))
  end

  test "format a value 5" do
    assert_equal "", show_value(OpenStruct.new())
  end

end
