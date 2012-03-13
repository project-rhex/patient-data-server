require 'test_helper'

class ApplicationControllerTest  < ActionController::TestCase
  test "breadcrumbs" do
    @controller.set_breadcrumbs
    assert_equal([{ :title => "Home", :link => "/"}], @controller.breadcrumbs)
  end
end