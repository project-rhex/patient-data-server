require 'test_helper'

class AuditLogsControllerTest < ActionController::TestCase
  include Devise::TestHelpers


  setup do
    @request.env["devise.mapping"] = Devise.mappings
    @user = FactoryGirl.create(:user)
    sign_in @user

    records = FactoryGirl.create_list(:record, 2)
    @record = records.first

    ## clean out auditlog table
    AuditLog.all.each {|x| x.destroy}
  end

  test "audit_log_get_index" do
    request.env['HTTP_ACCEPT'] = Mime::XML
    get :index
    assert_response :success
  end

  test "audit_log_log_create" do
    ## precondition - need audit log table empty
    audit_log = AuditLog.all.first
    assert_nil audit_log, "Audit log precondition FAIL - audit log table is NOT empty!"

    ## read a record
    request.env['HTTP_ACCEPT'] = Mime::XML
    get :test
    assert_response :success, "Unable to load audit log test"
    
    ## read the audit_log
    audit_log = AuditLog.all.first

    
    assert_not_nil audit_log, "Audit log table is empty!"
    assert_equal audit_log.description, "audit_logs|test", "Wrong test data in audit_log!"
  end

  
  test "audit_log_document" do
    ## precondition - need audit log table empty
    audit_log = AuditLog.all.first
    assert_nil audit_log, "Audit log precondition FAIL(2) - audit log table is NOT empty!"

    ## write an entry into log table
    desc = "foo"
    AuditLog.doc("NONE", "USER_ACTION", desc, @record, @record.version)

    ## read the audit_log
    audit_log = AuditLog.all.first
    assert_not_nil audit_log, "Audit log table is empty(2)!"
    
    

    ## check contents
      checksum1 = audit_log.checksum
    assert_not_nil checksum1, "checksum1 is nil!"
    assert_equal audit_log.version, 1, "version is not 1"
    assert_equal audit_log.obj_id, @record._id.to_s, "obj_id is incorrect (1)"

    ## update record
    @record.first = "Gregg"
    @record.save
    AuditLog.doc("NONE", "USER_ACTION", desc, @record, @record.version)

    ## read the audit_log table again, should have two entries, with the second entry having the folling values:
    audit_log = AuditLog.last
    
    
    assert_not_nil audit_log.checksum, "checksum is nil!"
    assert_not_equal audit_log.checksum, checksum1, "checksums are the same - should be different"
    assert_equal audit_log.version, 2, "version is not 2"
    assert_equal audit_log.obj_id, @record._id.to_s, "obj_id is incorrect (2)"
    

  end
  

end
