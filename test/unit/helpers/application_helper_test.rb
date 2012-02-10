require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase

  test "labeled field" do
    assert_equal "<div class='labeled_field'><span class='label'>foo</span><span class='value'>bar</span></div>",
                 labeled_field("foo", "bar")
  end

  test "date_formatter" do
    time = Time.new(2001, 1, 1)
    assert_equal "01/01/2001", date(time)
  end
end