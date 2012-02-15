require 'test_helper'

class AuditReviewControllerTest < ActionController::TestCase
  include Devise::TestHelpers

   setup do
    @request.env["devise.mapping"] = Devise.mappings
    @user = FactoryGirl.create(:user)
    sign_in @user

    @record_labs = FactoryGirl.create(:record, :with_lab_results)
    records = FactoryGirl.create_list(:record, 2)
    @record = records.first

    @audit_logs = FactoryGirl.create_list(:audit_log, 2)
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
    assert_not_nil @audit_log

    #STDOUT << @audit_logs.inspect
    #STDOUT << "\n====\n"
    #STDOUT << AuditLog.all( conditions: { event: /_access$/i } ).to_a.inspect
    #STDOUT << "\n====\n"
    review_docs = AuditLog.review_docs
    assert_not_nil review_docs
    #STDOUT << review_docs.inspect
    #assert_equal review_docs.count, "2", "audit_log not populated correctly"
    assert_equal review_docs[0].record_id, "1", "record_id is not 1"

    review_docs = AuditLog.review_doc(1)
    assert_not_nil review_docs
    #STDOUT << review_docs.inspect
    assert_equal review_docs.count, 1, "audit_log not populated correctly"
    assert_equal review_docs[0].record_id, "1", "record_id is not 1"


    ## update record
    @record.first = "Gregg"
    @record.save
    AuditLog.doc("NONE", "c32_access", "foo", @record, @record.medical_record_number, @record.version)
    #STDOUT << "\n====\n"
    #STDOUT << @record.inspect
    #STDOUT << "\n====\n"

    review_docs = AuditLog.review_doc(@record.medical_record_number)
    assert_not_nil review_docs
    #STDOUT << "\n====\n"
    #STDOUT << review_docs.inspect
    #STDOUT << "\n====\n"
    assert_equal review_docs.count, 2, "audit_log not populated correctly(2)"
    assert_equal review_docs[1].record_id, "2", "record_id is not 2 (2)"

    ## now get doc content itself 
    review_doc2 = AuditLog.review_doc_snapshot(@record.medical_record_number, @record.version)
    assert_not_nil review_doc2
    #STDOUT << "\n==== VERS #{@record.version} ===== \n"
    #STDOUT << review_doc2.inspect
    #STDOUT << "\n====\n"

    ## let's look at original version
    review_doc1 = AuditLog.review_doc_snapshot(@record.medical_record_number, 1)
    assert_not_nil review_doc1
    #STDOUT << "\n==== ORIG ===== \n"
    #STDOUT << review_doc1.inspect
    #STDOUT << "\n====\n"
    #STDOUT << @record_labs.lab_result.inspect #review_doc1.results.inspect
    #STDOUT << "\n====\n"
    assert_not_equal review_doc1.first, review_doc2.first, "record first names are the same!"
    #assert_equal review_docs[1].record_id, "1", "record_id is not 1 (2)"

  end
  
end
