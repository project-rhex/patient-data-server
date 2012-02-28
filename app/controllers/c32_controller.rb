class C32Controller < ApplicationController
  
  respond_to :xml, :json, :atom
  
  def index
    desc = audit_log "c32_index"
    respond_to do |wants|
      wants.atom {}
    end
  end

  
  def show
    desc = audit_log "c32_access"
    AuditLog.doc("NONE", "c32_access", desc, @record, @record.version)

    respond_with(@record)
  end


  def audit_log(action)
    return if current_user.nil?

    desc = ""
    desc = "record_id:#{params[:record_id]}" if params[:record_id]
    desc += "|id:#{params[:id]}" if params[:id]
    AuditLog.create(requester_info: current_user.email, event: action, description: desc)
    desc
  end

  
end
