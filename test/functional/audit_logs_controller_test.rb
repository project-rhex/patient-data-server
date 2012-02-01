require 'test_helper'
include Devise::TestHelpers

class AuditLogsControllerTest < ActionController::TestCase

  setup do
    ## clean out auditlog table
    AuditLog.all.each {|x| x.destroy}
  end

  test "audit log GET 'index'" do
    get :index
    assert_response :success
  end

  test "audit log confirm controller method logging" do
    ## precondition - need audit log table empty
    audit_log = AuditLog.all.first
    assert_nil audit_log, "Audit log precondition FAIL - audit log table is NOT empty!"

    ## read a record
    request.env['HTTP_ACCEPT'] = Mime::XML
    get :test
    assert_response :success, "Unable to load audit log test"
    
    ## read the audit_log
    audit_log = AuditLog.all.first
    #STDOUT << "\n===="
    #STDOUT << audit_log.class 
    #STDOUT << "\n"
    #STDOUT << audit_log.inspect
    #STDOUT << "\n====\n"
    assert_not_nil audit_log, "Audit log table is empty!"
    assert_equal audit_log.description, "audit_logs|test", "Wrong test data in audit_log!"
  end

end
