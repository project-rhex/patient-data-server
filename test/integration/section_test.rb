require "test_helper"

class SectionTest < ActionDispatch::IntegrationTest
  
  test "check that a put on a section causes a 405 error to be returned" do
    put section_url(1,"rest")
    assert_response 405
  end
  
  
end