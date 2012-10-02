require 'test_helper'

class VitalSignHostTest < ActiveSupport::TestCase
  test "generating the authorization request url" do
    vsh = FactoryGirl.create(:vital_sign_host)
    url = vsh.authorization_request_url('http://splat.blat.com')
    assert_equal 'foo.bar.com', url.host
    assert url.query.include? 'client_id=1234'
  end
end
