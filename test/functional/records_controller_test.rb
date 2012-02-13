require 'test_helper'

class RecordsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  # Called before every test method runs. Can be used
  # to set up fixture information.
  def setup
  end

  test "breadcrumbs" do
    assert_equal([{ :title => "Home", :link => "/"}, { :title => 'Patient Index'}], @controller.breadcrumbs)
  end
end