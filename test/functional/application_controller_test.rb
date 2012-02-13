require 'test_helper'

module ApplicationHelper
  def self.controller= value
    @controller = value
  end

  def controller
    @controller
  end
end

class ApplicationControllerTest  < ActionController::TestCase
  include ApplicationHelper

  test "breadcrumbs" do
    assert_equal([{ :title => "Home", :link => "/"}], @controller.breadcrumbs)
    assert_equal({ :title => "foo", :link => "bar"}, @controller.breadcrumb("foo", "bar"))
  end

  test "serialize breadcrumbs" do
    ApplicationHelper.controller = @controller
    assert_equal "<a href='/'>Home</a>", breadcrumbs
  end

  test "labeled field" do
    assert_equal "<div class='labeled_field'><span class='label'>foo</span><span class='value'>bar</span></div>",
                 labeled_field("foo", "bar")
  end

  test "date_formatter" do
    time = Time.new(2001, 1, 1)
    assert_equal "01/01/2001", date(time)
    # Check defaulting behavior with optional parameter
    assert_equal 'present', date(nil, 'present')
    # Check defaulting behavior with default value
    assert_equal 'never', date(nil)
  end
end