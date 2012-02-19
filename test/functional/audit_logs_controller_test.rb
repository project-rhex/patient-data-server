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
    #STDOUT << "\n===="
    #STDOUT << audit_log.class 
    #STDOUT << "\n"
    #STDOUT << audit_log.inspect
    #STDOUT << "\n====\n"
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
    #STDOUT << "\n==1==\n"
    #STDOUT << audit_log.inspect

    ## check contents
    #<AuditLog _id: 4f415900b61521163d000004, _type: nil, created_at: 2012-02-19 20:18:08 UTC, updated_at: 2012-02-19 20:18:08 UTC, requester_info: "NONE", event: "USER_ACTION", description: "foo", checksum: "6f3d0ba81bf36ec027756cbd838c5b75cb64abe7", obj_name: "Record", obj_id: "4f415900b61521163d000002", version: 1>
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
    #STDOUT << "\n==2==\n"
    #STDOUT << audit_log.inspect
    assert_not_nil audit_log.checksum, "checksum is nil!"
    assert_not_equal audit_log.checksum, checksum1, "checksums are the same - should be different"
    assert_equal audit_log.version, 2, "version is not 2"
    assert_equal audit_log.obj_id, @record._id.to_s, "obj_id is incorrect (2)"
    

  end
  

end
