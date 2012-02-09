require 'audit_doc'

class C32Controller < ApplicationController
  
  respond_to :xml, :json, :atom
  
  def index
    respond_to do |wants|
      wants.atom {}
    end
  end
  
  def show
    desc = "id:#{params[:id]}" if params[:id]
    AuditDoc.log("NONE", "USER_ACTION", desc, @record)

    respond_with(@record)
  end
  
end
