require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "labeled field" do
    assert_equal "<div class='labeled_field'><span class='label'>foo</span><span class='value'>bar</span></div>",
                 labeled_field("foo", "bar")
  end

  test "safe_date" do
    # Check that we can handle Times
    time = Time.new(2001, 1, 1)
    assert_equal time, safe_date(time) {|d| d}
    # Check that we can handle dates represented by Fixnum
    assert_equal Time.at(42), safe_date(42) {|d| d}
    # Check that we can handle dates represented by Bignum
    assert_equal Time.at(99999999999), safe_date(99999999999) {|d| d}
    # Check defaulting behavior
    assert_equal 'never', safe_date(nil)
    assert_equal 'foobar', safe_date(nil, 'foobar')
  end

  test "age_text_formatter" do
    # Check defaulting behavior
    assert_equal 'Forever Young', getAgeText(nil)
    time = Time.new(2001, 1, 1)
    assert_match "01-Jan-2001", getAgeText(time)
    # Check that we can handle dates represented by Fixnum
    assert_match "31-Dec-1969", getAgeText(42)
    # Check that we can handle dates represented by Bignum
    assert_match "16-Nov-5138", getAgeText(99999999999)
  end

  test "date_formatter" do
    time = Time.new(2001, 1, 1)
    assert_equal "01-Jan-2001", date(time)
    # Check defaulting behavior with optional parameter
    assert_equal 'present', date(nil, 'present')
    # Check defaulting behavior with default value
    assert_equal 'never', date(nil)
    # Check that we can handle dates represented by Fixnum
    assert_equal "31-Dec-1969", date(42)
    # Check that we can handle dates represented by Bignum
    assert_equal "16-Nov-5138", date(99999999999)
  end

  test "breadcrumbs" do
    @bc = [:title => "abc", :link => "/"]
    assert_equal "<a href='/'>abc</a>", show_breadcrumbs
    @bc = [{:title => "abc", :link => "/"}, {:title => "def"}]
    assert_equal "<a href='/'>abc</a>&nbsp;|&nbsp;def", show_breadcrumbs
  end

  def breadcrumbs
    @bc
  end
end
