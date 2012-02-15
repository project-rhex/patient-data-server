require 'test_helper'

class ApplicationControllerTest  < ActionController::TestCase
  test "breadcrumbs" do
    assert_equal([{ :title => "Home", :link => "/"}], @controller.breadcrumbs)
    assert_equal({ :title => "foo", :link => "bar"}, @controller.breadcrumb("foo", "bar"))
  end
end