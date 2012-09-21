require 'test_helper'

class AuditReviewControllerTest < ActionController::TestCase
  include Devise::TestHelpers

   setup do
    @request.env["devise.mapping"] = Devise.mappings
    @user = FactoryGirl.create(:user)
    sign_in @user

    ## clean out record table
    Record.all.each {|x| x.destroy}

    @record_with_labs = FactoryGirl.create(:record, :with_lab_results)
    records = FactoryGirl.create_list(:record, 2)
    @record = records.first

    ## clean out auditlog table
    AuditLog.all.each {|x| x.destroy}

    @audit_logs = FactoryGirl.create_list(:audit_log, 3)
    @audit_log = @audit_logs.first

  end

  test "audit_review_get_index" do
    get :index
    assert_response :success
  end

  test "audit_review_get_show" do
    get :show
    assert_response :success
  end


  test "audit_review_docs" do
    assert_not_nil @audit_log, "factory girl audit_log is nil"

    ## get test obj_id
    test_id = @audit_log.obj_id

    ## get list of all review docs (docs that end in _access)
    review_docs = AuditLog.review_docs
    assert_not_nil review_docs, "review_docs query failed"
    
    assert_equal 3, review_docs.count, "audit_log not populated correctly"
    assert_equal test_id, review_docs[0].obj_id, "obj_id is not #{test_id} (1)"

    ## get this specific doc
    review_docs = AuditLog.review_doc(test_id)
    assert_not_nil review_docs, "review_doc query failed"
    
    assert_equal review_docs.count, 1, "audit_log not populated correctly"
    assert_equal review_docs[0].obj_id, test_id, "obj_id is not #{test_id} (2)"

    ## update record, then test setting the log
    @record.first = "Gregg"
    @record.save
    AuditLog.doc("NONE", "c32_access", "test description", @record, @record.version)
    #

    review_docs = AuditLog.review_doc(@record._id)
    assert_not_nil review_docs, "review_doc query failed(2)"
    
    
    
    ##
    # TODO need to fix this test as the results varies depending if test is run individually versus group
    assert_equal review_docs.count, 1, "audit_log not populated correctly(2)"
    assert_equal review_docs[0].obj_id, @record._id.to_s, "obj_id is not #{@record._id} (2)"

    ## test review_doc_snapshot method
    ## negative tests
    review_doc2 = AuditLog.review_doc_snapshot("Array", @record._id, @record.version)
    assert_nil review_doc2, "review_doc_snapshot test 1 failed"
    review_doc2 = AuditLog.review_doc_snapshot("foo", @record._id, @record.version)
    assert_nil review_doc2, "review_doc_snapshot test 2 failed"
    ## postive test
    review_doc2 = AuditLog.review_doc_snapshot("Record", @record._id, @record.version)
    assert_not_nil review_doc2, "review_doc_snapshot test 3 failed"
    review_doc2 = AuditLog.review_doc_snapshot(@record.class, @record._id, @record.version)
    assert_not_nil review_doc2, "review_doc_snapshot test 4 failed"

    ## now get doc content itself 
    review_doc2 = AuditLog.review_doc_snapshot(@record, @record._id, @record.version)
    assert_not_nil review_doc2, "review_doc_snapshot lookup failed"


    ## let's look at original version
    review_doc1 = AuditLog.review_doc_snapshot(@record, @record._id, 1)
    assert_not_nil review_doc1, "review_doc_snapshot lookup failed (2)"

    ## compare first names across versions
    assert_not_equal review_doc1.first, review_doc2.first, "record first names are the same - they should be different!"
  
  end
  
end
