require 'test_helper'

class RecordHelperTest < ActionView::TestCase
  test "calculate_age" do
    assert_equal "0", calculate_age(Time.now)
  end

  test "record_simple_value" do
    assert_equal "<div class='simple_value'>foobar</div>", record_simple_value("foobar")
  end

  test "patient_name" do
    @record = FactoryGirl.create(:record)
    assert_equal "<span id='patient_name'>Doe,&nbsp;John</span>",  patient_name
  end
  
end