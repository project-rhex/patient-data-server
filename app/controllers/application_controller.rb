class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :find_record, :audit_log_all

  # Return a list of breadcrumbs appropriate for the particular controller. This method can be overridden by
  # any specific subclass to introduce sublinks into the breadcrumb path. A leaf path can then be introduced by
  # the local controller by convention using local code
  def breadcrumbs
    [ breadcrumb("Home", root_path) ]
  end

  # Hold a single link's data in a hash
  def breadcrumb title, link = nil
    if link.nil?
      { :title => title }
    else
      { :title => title, :link => link }
    end
  end

  private
  
  def find_record
    record_id = params[:record_id] || params[:id]
    @record = Record.first(conditions: {medical_record_number: record_id})
  end

  # Handle no record, return false if we're ok. That way callers can just
  # include the line
  # return if missing_record?
  def missing_record?
    render file: "public/404.html", :status => :not_found unless @record
    @record.nil?
  end


  ##
  ## Track each controller and method (action) call
  def audit_log_all
    ## 
    #puts current_user.inspect

    if  params[:controller] && params[:action]
      desc = params[:controller] + "|" + params[:action]
      desc << "|id:#{params[:id]}" if params[:id]

      ## log user email for now
      ## TODO: change to larger requester info set
      if current_user
        if desc =~ /sessions\|destroy/
          desc << "|LOGOUT"
        end

        AuditLog.create(requester_info: current_user.email, event: "USER_ACTION", description: desc)
      else
        AuditLog.create(requester_info: "NONE", event: "USER_ACTION", description: desc)
      end

    end

  end

end
