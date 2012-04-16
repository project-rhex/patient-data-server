class AuditReviewController < ApplicationController
 
  def index

    ## get all log event that end in _access
    @audit_docs = AuditLog.review_docs

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @audit_docs }
    end
  end

  
  def show

    # assume this is the medical_records_number
    mrn = params[:id]
    @audit_docs = AuditLog.review_doc( mrn )

    respond_to do |format|
      format.html
      format.xml  { render :xml => @audit_docs }
    end

   end


end
