class ApplicationController < ActionController::Base
  protect_from_forgery

  
  before_filter :find_record, :audit_log
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
