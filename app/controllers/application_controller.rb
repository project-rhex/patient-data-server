class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :find_record, :audit_log

  # Return a list of breadcrumbs appropriate for the particular controller. This method can be overridden by
  # any specific subclass to introduce sublinks into the breadcrumb path. A leaf path can then be introduced by
  # the local controller by convention using local code
  def breadcrumbs
    [ breadcrumb("Home", root_path) ]
  end

  # Hold a single link's data in a hash
  def breadcrumb title, link
    { :title => title, :link => link }
  end

  private
  
  def find_record
    record_id = params[:record_id] || params[:id]
    @record = Record.first(conditions: {medical_record_number: record_id})
    ##render file: "public/404.html", :status => :not_found unless @record
  end


  ##
  ## Track each controller and method (action) call
  def audit_log
    ## 
    if  params[:controller] && params[:action]
      desc = params[:controller] + "|" + params[:action]
      desc << "|id:#{params[:id]}" if params[:id]

      AuditLog.create(:username => "tsmith", :event => "USER_ACTION", :description => desc)
    end

  end

end
